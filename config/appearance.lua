local gpu_adapters = require('utils.gpu_adapter')
local backdrops = require('utils.backdrops')
local colors = require('colors.custom')

local platform = require('utils.platform')

local wezterm = require('wezterm')
local config = {
   max_fps = 120,
   front_end = 'WebGpu',
   webgpu_power_preference = 'HighPerformance',
   webgpu_preferred_adapter = gpu_adapters:pick_best(),
   animation_fps = 120,
   cursor_blink_ease_in = 'EaseOut',
   cursor_blink_ease_out = 'EaseOut',
   default_cursor_style = 'BlinkingBlock',
   cursor_blink_rate = 650,
   colors = colors,
   background = backdrops:create_opts(),
   enable_scroll_bar = true,
   window_padding = {
      left = 0,
      right = 0,
      top = 10,
      bottom = 7.5,
   },
   adjust_window_size_when_changing_font_size = false,
   window_close_confirmation = 'NeverPrompt',
   window_frame = {
      active_titlebar_bg = colors.background,
   },
   inactive_pane_hsb = {
      saturation = 0.9,
      brightness = 0.45,
   },
}

if platform.is_mac or platform.is_win then
   config.window_decorations = 'RESIZE'
else
   -- NOTE: Override a crappy deault
   config.window_decorations = 'NONE'
end

local function enable_tab_plugin(which, tabline_conf)
   if which == 'tabline' then
      -- ── Tabline plugin (highly customizable) ───────────────────────
      local tabline = wezterm.plugin.require('https://github.com/michaelbrusegard/tabline.wez')
      tabline.setup({
         options = {
            -- theme = "Catppuccin Mocha",
            colors = colors,
            section_separators = {
               left = wezterm.nerdfonts.pl_left_hard_divider,
               right = wezterm.nerdfonts.pl_right_hard_divider,
            },
            component_separators = {
               left = wezterm.nerdfonts.pl_left_soft_divider,
               right = wezterm.nerdfonts.pl_right_soft_divider,
            },
            tab_separators = {
               left = wezterm.nerdfonts.pl_left_hard_divider,
               right = wezterm.nerdfonts.pl_right_hard_divider,
            },
         },
      })

      tabline.apply_to_config(tabline_conf)
   elseif which == 'bar' then
      -- ── Bar plugin (simpler, bottom‑bar style) ───────────────────────
      local bar = wezterm.plugin.require('https://github.com/adriankarlen/bar.wezterm')
      bar.apply_to_config(tabline_conf, {
         zoom = {
            enabled = false,
            icon = wezterm.nerdfonts.md_fullscreen,
            color = 4,
         },
      })

      -- Optional tab‑bar settings that make sense with `bar.wezterm`
      tabline_conf = {
         enable_tab_bar = true,
         hide_tab_bar_if_only_one_tab = false,
         use_fancy_tab_bar = true,
         tab_max_width = 25,
         show_tab_index_in_tab_bar = false,
         switch_to_last_active_tab_when_closing_tab = true,
      }
   else
      error('Unsupported plugin name: ' .. tostring(which) .. '. Use "tabline" or "bar".')
   end

   return tabline_conf
end

-- HACK: Easy switch bars. Options: "tabline", "bar"
config = enable_tab_plugin('tabline', config)
return config
