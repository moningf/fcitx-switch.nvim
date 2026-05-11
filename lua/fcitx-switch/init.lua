local M = {}

function M.to_english()
  vim.system({ "fcitx5-remote", "-c" })
end

function M.setup()
  -- 检查是否存在
  if vim.fn.executable("fcitx5-remote") == 0 then
    return
  end

  -- 创建自动命令
  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = M.to_english
  })
end

return M
