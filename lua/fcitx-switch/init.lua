local M = {}

function M.to_english()
  vim.system({ "fcitx5-remote", "-c" })
end

-- 初始化函数
function M.setup()
  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      M.to_english()
    end
  })
end

return M
