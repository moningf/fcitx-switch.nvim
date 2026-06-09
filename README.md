# fcitx-switch.nvim

自动管理 fcitx5 输入法状态的 Neovim 插件。离开插入模式时切回英文，进入时恢复之前的输入法，支持多种策略灵活控制。

## 依赖

- [fcitx5](https://github.com/fcitx/fcitx5) 输入法框架
- Neovim >= 0.10
- **comment 策略** 需要对应语言的 [Tree-sitter parser](https://github.com/nvim-treesitter/nvim-treesitter#quickstart)

## 安装

### lazy.nvim

```lua
{
  "moningf/fcitx-switch.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("fcitx-switch").setup({
      -- 默认配置
      default_im = "keyboard-us",
      preferred_im = "rime",
      obtain_command = "/usr/bin/fcitx5-remote -n",
      -- 使用{im}做占位符
      switch_command = "/usr/bin/fcitx5-remote -s {im}",
      strategies = {
        markdown = "preferred_im",
        comment = "preferred_im",
        default = "auto",
      },
    })
  end,
}
```

## 默认行为

- **InsertLeave** — 记录当前输入法，切换到 `default_im`（英文）
- **InsertEnter** — 按策略决定切换到什么输入法

## 配置

| 选项 | 说明 | 默认值 |
|------|------|--------|
| `default_im` | normal 模式使用的输入法 | `"keyboard-us"` |
| `preferred_im` | 中文输入法 | `"rime"` |
| `obtain_command` | 获取当前输入法的命令 | `"/usr/bin/fcitx5-remote -n"` |
| `switch_command` | 切换输入法命令，`{im}` 会被替换 | `"/usr/bin/fcitx5-remote -s {im}"` |
| `strategies` | 策略配置，见下文 | — |

## 策略

进入插入模式时，按以下优先级依次检查，命中的第一个策略决定切换到什么输入法。

策略值可以是：
- **输入法名**（`"rime"`, `"keyboard-us"`）— 直接切到该输入法
- **字段引用**（`"preferred_im"`, `"default_im"`, `"last_im"`）— 指向对应配置项的值
- **`"auto"`** — 根据光标前一个字符类型自动判断
- **`false` 或 `nil`** — 跳过该策略，继续下一个

---

### markdown

匹配 markdown 文件。基于 `vim.bo.filetype` 判断。

```lua
strategies = {
  markdown = "preferred_im",   -- md 文件始终切中文
  -- markdown = "keyboard-us", -- md 文件始终切英文
  -- markdown = "auto",        -- md 文件也自动判断
  -- markdown = false,         -- md 文件不特殊处理
}
```

### comment

匹配注释区域。基于 **Tree-sitter** 检测光标前的字符是否属于注释节点。

需要 `nvim-treesitter` 并安装对应语言的 parser，否则静默跳过。

```lua
strategies = {
  comment = "preferred_im",   -- 注释中切中文
  -- comment = "keyboard-us", -- 注释中切英文
  -- comment = false,         -- 禁用注释检测
}
```

### auto

自动判断光标前一个字符的类型：**中文字符** → 切 `preferred_im`；**英文 / 数字 / 其他** → 切 `default_im`。行首无字符时切 `default_im`。

不单独启用，通过将任意策略值设为 `"auto"` 生效。

```lua
strategies = {
  default = "auto",  -- 其他场景用 auto 自动判断
}
```

### default

兜底策略。当以上策略都未命中时使用。

```lua
strategies = {
  default = "auto",       -- 自动判断中英文（默认）
  -- default = "preferred_im", -- 始终切中文
  -- default = "auto",         -- 自动判断中英文
  -- default = false,          -- 不切换，保持当前状态
}
```

---

### 完整示例

```lua
require("fcitx-switch").setup({
  default_im = "keyboard-us",
  preferred_im = "rime",
  strategies = {
    markdown = "preferred_im",   -- md 文件切中文
    comment = "preferred_im",    -- 注释中切中文
    default = "auto",            -- 其他场景自动判断
  },
})
```

离开插入模式时始终切换回 `default_im`（英文），以上只影响进入时的行为。

## 许可

MIT
