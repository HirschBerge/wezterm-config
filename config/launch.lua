local platform = require('utils.platform')

local options = {
   default_prog = {},
   launch_menu = {},
}

if platform.is_win then
   options.default_prog = { 'pwsh', '-NoLogo' }
   options.launch_menu = {
      { label = 'PowerShell Core',         args = { 'pwsh', '-NoLogo' } },
      { label = 'PowerShell Core (Admin)', args = { "pwsh", "-Noni", "-NoLogo", "-Command", "Start-Process", "-Verb", "RunAs", "wezterm" } },
      { label = 'PowerShell Desktop',      args = { 'powershell' } },
      { label = 'Command Prompt',          args = { 'cmd' } },
      { label = 'Nushell',                 args = { 'nu' } },
      {
         label = 'Git Bash',
         args = { 'C:\\Users\\kevin\\scoop\\apps\\git\\current\\bin\\bash.exe' },
      },
   }
elseif platform.is_mac then
   options.default_prog = { 'fish', '-l' }
   options.launch_menu = {
      { label = 'Bash',    args = { 'bash', '-l' } },
      { label = 'Fish',    args = { '/opt/homebrew/bin/nu', '-l' } },
      { label = 'Nushell', args = { '/etc/profiles/per-user/hkirkwoo/bin/nu', '-l' } },
      { label = 'Zsh',     args = { 'zsh', '-l' } },
   }
elseif platform.is_linux then
   options.default_prog = { 'fish', '-l' } --NOTE: I actually use nushell primarily, but zsh has zellij auto-start enabled
   options.launch_menu = {
      { label = 'Nu',   args = { 'nu', '-l' } },
      { label = 'Fish', args = { 'fish', '-l' } },
      { label = 'Bash', args = { 'bash', '-l' } },
   }
end

return options
