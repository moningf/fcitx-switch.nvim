local config_mod = require("fcitx-switch.config")

local M = {}

local function parse_cmd(str)
  local parts = {}
  for part in str:gmatch("%S+") do
    table.insert(parts, part)
  end
  return parts
end

function M.switch_to(im)
  local cmd = parse_cmd(config_mod.config.switch_command)
  for i, part in ipairs(cmd) do
    cmd[i] = string.gsub(part, "{im}", im)
  end
  vim.system(cmd)
end

function M.obtain_current_im()
  local result = vim.fn.system(parse_cmd(config_mod.config.obtain_command))
  return vim.trim(result)
end

return M
