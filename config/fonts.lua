local wezterm = require('wezterm')
local platform = require('utils.platform')

-- local font = 'Maple Mono SC NF'
local jetbrains = 'JetBrainsMono Nerd Font'
local font_family  = 'Dank Mono'
local font_size = platform.is_mac and 12 or 11

-- Set JetBrains Mono Bold Italic for bold and italic text
return {
   font = wezterm.font({
      family = font_family,
      weight = 'Medium',
   }),

   font_rules = {
      -- Rule for bold text
      {
         intensity = "Bold",
         italic = false,
         font = wezterm.font(jetbrains, { weight = 'Bold' }),
      },
      -- Rule for italic text
      {
         intensity = "Normal",
         italic = true,
         font = wezterm.font(font_family, { italic = true }),
      },
      -- Rule for bold italic text
      {
         intensity = "Bold",
         italic = true,
         font = wezterm.font(jetbrains, { weight = 'Bold', italic = true }),
      },
   },
   font_size = font_size,

   --ref: https://wezfurlong.org/wezterm/config/lua/config/freetype_pcf_long_family_names.html#why-doesnt-wezterm-use-the-distro-freetype-or-match-its-configuration
   freetype_load_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
   freetype_render_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
}
