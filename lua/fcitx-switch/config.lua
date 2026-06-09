local M = {}

M.config = {
  default_im = "keyboard-us",
  preferred_im = "rime",
  obtain_command = "/usr/bin/fcitx5-remote -n",
  switch_command = "/usr/bin/fcitx5-remote -s {im}",
  last_im = nil,
  strategies = {
    markdown = "preferred_im",
    comment = "preferred_im",
    default = "auto",
  },
}

function M.merge(user_opts)
  M.config = vim.tbl_deep_extend("force", M.config, user_opts or {})
  return M.config
end

return M
