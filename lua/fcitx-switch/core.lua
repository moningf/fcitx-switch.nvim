local config_mod = require("fcitx-switch.config")

local M = {}

function M.switch_to(im)
  local cmd = string.gsub(config_mod.config.switch_command, "{im}", im)
  vim.system({ "sh", "-c", cmd })
end

function M.obtain_current_im()
  local result = vim.fn.system(config_mod.config.obtain_command)
  return vim.trim(result)
end

return M
