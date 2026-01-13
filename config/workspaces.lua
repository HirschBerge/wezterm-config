local wezterm = require('wezterm')
local mux = wezterm.mux
local config = wezterm.config_builder()
wezterm.on('gui-startup', function(cmd)
   -- allow `wezterm start -- something` to affect what we spawn
   -- in our initial window
   local args = {}
   if cmd then
      args = cmd.args
   end

   local tab, Neovim, window = mux.spawn_window({
      workspace = 'Normal',
      cwd = wezterm.home_dir,
      args = args,
   })
   local term_pane = Neovim:split({
      direction = 'Right',
      size = 0.25,
      cwd = wezterm.home_dir,
   })
   local yazi = term_pane:split({
      direction = 'Bottom',
      size = 0.5,
      cwd = wezterm.home_dir,
   })
   Neovim:send_text('v\n')
   yazi:send_text('yazi\n')

   -- We want to startup in the Normal workspace
   mux.set_active_workspace('Normal')
end)

return config
