local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local session_restore = wezterm.plugin.require 'https://github.com/neerajsingh0101/wezterm-session-restore'
session_restore.setup(config)

return config
