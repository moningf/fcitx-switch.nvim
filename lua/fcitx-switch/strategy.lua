local config_mod = require("fcitx-switch.config")

local M = {}

function M.resolve_im(key_or_name)
  return config_mod.config[key_or_name] or key_or_name
end

local function get_prev_char()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  if col == 0 then return nil end
  return vim.fn.matchstr(line:sub(1, col), '.$')
end

local function is_chinese(char)
  if not char or char == "" then return false end
  local code = vim.fn.char2nr(char)
  return (code >= 0x4e00 and code <= 0x9fff)
      or (code >= 0x3400 and code <= 0x4dbf)
      or (code >= 0xf900 and code <= 0xfaff)
end

function M.apply_auto_strategy()
  local prev = get_prev_char()
  if prev and is_chinese(prev) then
    return config_mod.config.preferred_im
  elseif prev then
    return config_mod.config.default_im
  end
  return config_mod.config.default_im
end

function M.get_insert_im()
  local config = config_mod.config

  if vim.bo.filetype == "markdown" and config.strategies.markdown then
    return M.resolve_im(config.strategies.markdown)
  end

  if config.strategies.comment then
    local buf = vim.api.nvim_get_current_buf()
    local ok, parser = pcall(vim.treesitter.get_parser, buf)
    if ok and parser then
      parser:parse()
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      local pos_col = col > 0 and (col - 1) or col
      local node = vim.treesitter.get_node({ bufnr = buf, pos = { row - 1, pos_col } })
      while node do
        if node:type():match("comment") then
          return M.resolve_im(config.strategies.comment)
        end
        node = node:parent()
      end
    end
  end

  if config.strategies.default then
    return M.resolve_im(config.strategies.default)
  end

  return config.preferred_im
end

return M
