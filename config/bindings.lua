local wezterm = require('wezterm')
local platform = require('utils.platform')
local backdrops = require('utils.backdrops')
local act = wezterm.action
local mod = {}

if platform.is_mac then
   mod.SUPER = 'SUPER'
   mod.SUPER_REV = 'SUPER|CTRL'
   -- NOTE: Mac and Linux i use zellij but windows I don't so for the real multiplexering I want to keep the bindings the same, but keep a reasonable binding
   mod.SUPER_DUPER = "SUPER|SHIFT"
elseif platform.is_win then
   mod.SUPER = 'ALT' -- to not conflict with Windows key shortcuts
   mod.SUPER_REV = 'ALT|CTRL'
   -- NOTE: Mac and Linux i use zellij but windows I don't so for the real multiplexering I want to keep the bindings the same, but keep a reasonable binding
   mod.SUPER_DUPER = mod.SUPER
elseif platform.is_linux then
   mod.SUPER = 'ALT' -- to not conflict with zellij
   mod.SUPER_REV = 'ALT|CTRL'
   -- NOTE: Mac and Linux i use zellij but windows I don't so for the real multiplexering I want to keep the bindings the same, but keep a reasonable binding
   mod.SUPER_DUPER = 'ALT|SHIFT'
end

local function is_vim(pane)
   -- this is set by the plugin, and unset on ExitPre in Neovim
   return pane:get_user_vars().IS_NVIM == 'true'
end

local direction_keys = {
   h = 'Left',
   j = 'Down',
   k = 'Up',
   l = 'Right',
}
local function split_nav(resize_or_move, key)
   return {
      key = key,
      mods = resize_or_move == 'resize' and "CTRL|SHIFT" or mod.SUPER,
      action = wezterm.action_callback(function(win, pane)
         if is_vim(pane) then
            -- pass the keys through to vim/nvim
            win:perform_action({
               SendKey = { key = key, mods = resize_or_move == 'resize' and "CTRL|SHIFT" or mod.SUPER },
            }, pane)
         else
            if resize_or_move == 'resize' then
               win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
            else
               win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
            end
         end
      end),
   }
end
-- stylua: ignore
local keys = {

   split_nav('move', 'h'),
   split_nav('move', 'j'),
   split_nav('move', 'k'),
   split_nav('move', 'l'),
   -- resize panes
   split_nav('resize', 'h'),
   split_nav('resize', 'j'),
   split_nav('resize', 'k'),
   split_nav('resize', 'l'),
   -- misc/useful --
   { key = 'F1', mods = 'NONE', action = 'ActivateCopyMode' },
   { key = 'F2', mods = 'NONE', action = act.ActivateCommandPalette },
   { key = 'F3', mods = 'NONE', action = act.ShowLauncher },
   { key = 'F4', mods = 'NONE', action = act.ShowLauncherArgs({ flags = 'FUZZY|TABS' }) },
   {
      key = 'F5',
      mods = 'NONE',
      action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }),
   },
   { key = 'F11', mods = 'NONE',       action = act.ToggleFullScreen },
   { key = 'F12', mods = 'NONE',       action = act.ShowDebugOverlay },
   { key = 'f',   mods = 'CTRL|SHIFT', action = act.Search({ CaseInSensitiveString = '' }) },
   {
      key = 'u',
      mods = mod.SUPER,
      action = wezterm.action.QuickSelectArgs({
         label = 'open url',
         patterns = {
            -- Match common URL patterns, excluding '⋅'
            '\\((https?://[^⋅\\s]+)\\)',
            '\\[(https?://[^⋅\\s]+)\\]',
            '\\{(https?://[^⋅\\s]+)\\}',
            '<(https?://[^⋅\\s]+)>',
            '\\bhttps?://[^⋅\\s]+[)/a-zA-Z0-9-]+',
            -- NOTE: Match GitHub repository pattern (e.g., 'mrcjkb/rustaceanvim')
            '\'([a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+)\'',
         },
         action = wezterm.action_callback(function(window, pane)
            local text = window:get_selection_text_for_pane(pane)
            --INFO: allows easily accessing git repos for certain neovim users.
            local user, repo = string.match(text, '([a-zA-Z0-9_.-]+)/([a-zA-Z0-9_.-]+)')
            local url
            if user and repo and not text:find('http') then
               -- Build the GitHub URL
               url = string.format('https://github.com/%s/%s', user, repo)
            else
               -- Treat it as a regular URL
               url = text
            end
            if string.match(string.lower(url), "youtube") then
               os.execute("wl-copy '" .. url .. "'")
               os.execute("zp")
            else
               wezterm.log_info('Opening: ' .. url)
               wezterm.open_with(url)
            end
         end),
      }),
   },

   -- cursor movement --
   { key = 'LeftArrow',  mods = mod.SUPER,     action = act.SendString '\x1bOH' },
   { key = 'RightArrow', mods = mod.SUPER,     action = act.SendString '\x1bOF' },
   { key = 'Backspace',  mods = mod.SUPER,     action = act.SendString '\x15' },

   -- copy/paste --
   { key = 'c',          mods = 'CTRL|SHIFT',  action = act.CopyTo('Clipboard') },
   { key = 'v',          mods = 'CTRL|SHIFT',  action = act.PasteFrom('Clipboard') },

   -- tabs --
   -- tabs: spawn+close
   { key = 't',          mods = mod.SUPER,     action = act.SpawnTab('DefaultDomain') },
   { key = 't',          mods = mod.SUPER_REV, action = act.SpawnTab({ DomainName = 'docker' }) },
   { key = 'w',          mods = mod.SUPER_REV, action = act.CloseCurrentTab({ confirm = false }) },

   -- tabs: navigation
   { key = '[',          mods = mod.SUPER,     action = act.ActivateTabRelative(-1) },
   { key = ']',          mods = mod.SUPER,     action = act.ActivateTabRelative(1) },
   { key = '[',          mods = mod.SUPER_REV, action = act.MoveTabRelative(-1) },
   { key = ']',          mods = mod.SUPER_REV, action = act.MoveTabRelative(1) },

   { key = '0',          mods = mod.SUPER,     action = act.EmitEvent('tabs.manual-update-tab-title') },
   { key = '0',          mods = mod.SUPER_REV, action = act.EmitEvent('tabs.reset-tab-title') },

   -- tab: hide tab-bar
   { key = '9',          mods = mod.SUPER,     action = act.EmitEvent('tabs.toggle-tab-bar'), },

   {
      key = 'n',
      mods = mod.SUPER,
      action = act.SplitPane({
         direction = 'Up',
         command = {
            args = { 'nu' }
         }
      })
   },
   {
      key = 'n',
      mods = mod.SUPER_REV,
      action = act.SplitPane({
         direction = 'Right',
         command = {
            args = { 'nu' }
         }
      })
   },

   -- window: zoom window
   {
      key = '-',
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         local dimensions = window:get_dimensions()
         if dimensions.is_full_screen then
            return
         end
         local new_width = dimensions.pixel_width - 50
         local new_height = dimensions.pixel_height - 50
         window:set_inner_size(new_width, new_height)
      end)
   },
   {
      key = '=',
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         local dimensions = window:get_dimensions()
         if dimensions.is_full_screen then
            return
         end
         local new_width = dimensions.pixel_width + 50
         local new_height = dimensions.pixel_height + 50
         window:set_inner_size(new_width, new_height)
      end)
   },

   -- background controls --
   {
      key = [[/]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:random(window)
      end),
   },
   {
      key = [[,]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:cycle_back(window)
      end),
   },
   {
      key = [[.]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:cycle_forward(window)
      end),
   },
   {
      key = [[/]],
      mods = mod.SUPER_REV,
      action = act.InputSelector({
         title = 'InputSelector: Select Background',
         choices = backdrops:choices(),
         fuzzy = true,
         fuzzy_description = 'Select Background: ',
         action = wezterm.action_callback(function(window, _pane, idx)
            if not idx then
               return
            end
            ---@diagnostic disable-next-line: param-type-mismatch
            backdrops:set_img(window, tonumber(idx))
         end),
      }),
   },
   {
      key = 'b',
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:toggle_focus(window)
      end)
   },

   -- panes --
   -- panes: split panes
   {
      key = [[\]],
      mods = mod.SUPER,
      action = act.SplitVertical({ domain = 'CurrentPaneDomain' }),
   },
   {
      key = [[\]],
      mods = mod.SUPER_REV,
      action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
   },

   -- panes: zoom+close pane
   { key = 'Enter', mods = mod.SUPER, action = act.TogglePaneZoomState },
   { key = 'f',     mods = mod.SUPER, action = act.TogglePaneZoomState },
   { key = 'w',     mods = mod.SUPER, action = act.CloseCurrentPane({ confirm = false }) },

   {
      key = 'p',
      mods = mod.SUPER_REV,
      action = act.PaneSelect({ alphabet = '1234567890', mode = 'SwapWithActiveKeepFocus' }),
   },

   -- panes: scroll pane
   -- { key = 'u',        mods = mod.SUPER, action = act.ScrollByLine(-5) },
   -- { key = 'd',        mods = mod.SUPER, action = act.ScrollByLine(5) },
   { key = 'PageUp',   mods = 'NONE', action = act.ScrollByPage(-0.75) },
   { key = 'PageDown', mods = 'NONE', action = act.ScrollByPage(0.75) },

   -- key-tables --
   -- resizes fonts
   {
      key = 'f',
      mods = mod.SUPER_DUPER,
      action = act.ActivateKeyTable({
         name = 'resize_font',
         one_shot = false,
         timemout_miliseconds = 1000,
      }),
   },
   -- resize panes
   {
      key = 'p',
      mods = mod.SUPER,
      action = act.ActivateKeyTable({
         name = 'resize_pane',
         one_shot = false,
         timemout_miliseconds = 1000,
      }),
   },
}

-- stylua: ignore
local key_tables = {
   resize_font = {
      { key = 'k',      action = act.IncreaseFontSize },
      { key = 'j',      action = act.DecreaseFontSize },
      { key = 'r',      action = act.ResetFontSize },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q',      action = 'PopKeyTable' },
   },
   resize_pane = {
      { key = 'k',      action = act.AdjustPaneSize({ 'Up', 1 }) },
      { key = 'j',      action = act.AdjustPaneSize({ 'Down', 1 }) },
      { key = 'h',      action = act.AdjustPaneSize({ 'Left', 1 }) },
      { key = 'l',      action = act.AdjustPaneSize({ 'Right', 1 }) },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q',      action = 'PopKeyTable' },
   },
}

local mouse_bindings = {
   -- Ctrl-click will open the link under the mouse cursor
   {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = act.OpenLinkAtMouseCursor,
   },
}

return {
   disable_default_key_bindings = true,
   -- disable_default_mouse_bindings = true,
   leader = { key = 'Space', mods = mod.SUPER_REV },
   keys = keys,
   key_tables = key_tables,
   mouse_bindings = mouse_bindings,
}
