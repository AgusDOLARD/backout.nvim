# backout.nvim

## 📖 Overview

`backout.nvim` is a minimal neovim plugin designed to move inline while remaining in insert mode. This plugin is inspired by functionality from [auto-pairs](https://github.com/jiangmiao/auto-pairs) that I couldn't find in other auto-pair plugins.

### Example

![Example](https://vhs.charm.sh/vhs-5zjoLQoKJKK1DQBld3RQRp.gif)

## 🚀 Installation

- [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
return {
	"AgusDOLARD/backout.nvim",
	opts = {},
	keys = {
        -- Define your keybinds
		{ "<M-b>", "<cmd>lua require('backout').back()<cr>", mode = { "i", "c" } },
		{ "<M-n>", "<cmd>lua require('backout').out()<cr>", mode = { "i", "c" } },
	},
}
```

## ⚙️ Options

### chars

A string containing characters or sequences to jump between

```lua
    chars = "(){}[]`'\"<>" -- default chars
```

### multiLine

Enable/Disable multi line movement

```lua
    multiLine = true -- enabled by default
```

### logLevel

Log levels to show in console

```lua
    logLevel = "error" -- "trace"|"debug"|"info"|"error"|"fatal"
```


## 🤝 Contributions

Contributions are welcome! Feel free to open issues, submit pull requests, or provide feedback to help improve backout.nvim.
