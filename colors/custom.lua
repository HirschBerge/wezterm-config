local wezterm = require('wezterm')
local custom_cat = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
custom_cat.cursor_bg = "#cba6f7"

return custom_cat
