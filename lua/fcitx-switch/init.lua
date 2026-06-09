local M = {}

local config_mod = require("fcitx-switch.config")
local core = require("fcitx-switch.core")
local strategy = require("fcitx-switch.strategy")

local function on_insert_leave()
  config_mod.config.last_im = core.obtain_current_im()
  core.switch_to(config_mod.config.default_im)
end

local function on_insert_enter()
  local target = strategy.get_insert_im()
  if target == "auto" then
    target = strategy.apply_auto_strategy()
  end
  if target then
    core.switch_to(target)
  end
end

function M.setup(user_opts)
  local config = config_mod.merge(user_opts)

  local cmd_name = config.obtain_command:match("^(%S+)")
  if vim.fn.executable(cmd_name) == 0 then
    return
  end

  vim.api.nvim_create_autocmd("InsertLeave", { callback = on_insert_leave })
  vim.api.nvim_create_autocmd("InsertEnter", { callback = on_insert_enter })
end

return M
