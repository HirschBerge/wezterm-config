local username = os.getenv("USER") or os.getenv("USERNAME")
return {
   -- ref: https://wezfurlong.org/wezterm/config/lua/SshDomain.html
   ssh_domains = {
      {
         name = 'Rasp Pi',
         remote_address = 'server_nixos',
         multiplexing = 'None',
         username = username,
         -- When multiplexing == "None", default_prog can be used
         -- to specify the default program to run in new tabs/panes.
         -- Due to the way that ssh works, you cannot specify default_cwd,
         -- but you could instead change your default_prog to put you
         -- in a specific directory.
         default_prog = { 'nu' },

         -- assume that we can use syntax like:
         -- "env -C /some/where $SHELL"
         -- using whatever the default command shell is on this
         -- remote host, so that shell integration will respect
         -- the current directory on the remote host.
         -- assume_shell = 'Posix',
         ssh_option = {
            identityfile = '/run/secrets/rasp_pi_ssh',
         },
      },
      {
         name = 'NixOS Server',
         remote_address = 'server_nixos',
         multiplexing = 'None',
         username = username,
         -- When multiplexing == "None", default_prog can be used
         -- to specify the default program to run in new tabs/panes.
         -- Due to the way that ssh works, you cannot specify default_cwd,
         -- but you could instead change your default_prog to put you
         -- in a specific directory.
         default_prog = { 'nu' },

         -- assume that we can use syntax like:
         -- "env -C /some/where $SHELL"
         -- using whatever the default command shell is on this
         -- remote host, so that shell integration will respect
         -- the current directory on the remote host.
         -- assume_shell = 'Posix',
         ssh_option = {
            identityfile = '/run/secrets/server_ssh',
         },
      },
      {
         name = 'shirohebi',
         remote_address = 'host-shirohebi',
         multiplexing = "WezTerm",
         username = username,
         -- When multiplexing == "None", default_prog can be used
         -- to specify the default program to run in new tabs/panes.
         -- Due to the way that ssh works, you cannot specify default_cwd,
         -- but you could instead change your default_prog to put you
         -- in a specific directory.
         -- default_prog = { 'zsh' },

         -- assume that we can use syntax like:
         -- "env -C /some/where $SHELL"
         -- using whatever the default command shell is on this
         -- remote host, so that shell integration will respect
         -- the current directory on the remote host.
         -- assume_shell = 'Posix',
         ssh_option = {
            identityfile = '/run/secrets/laptop_ssh',
         },
      },
      {
         name = 'yoitsu',
         remote_address = 'host-yoitsu',
         multiplexing = "WezTerm",
         username = username,
         -- When multiplexing == "None", default_prog can be used
         -- to specify the default program to run in new tabs/panes.
         -- Due to the way that ssh works, you cannot specify default_cwd,
         -- but you could instead change your default_prog to put you
         -- in a specific directory.
         -- default_prog = { 'zsh' },

         -- assume that we can use syntax like:
         -- "env -C /some/where $SHELL"
         -- using whatever the default command shell is on this
         -- remote host, so that shell integration will respect
         -- the current directory on the remote host.
         -- assume_shell = 'Posix',
         ssh_option = {
            identityfile = '/run/secrets/desktop_ssh',
         },
      },
   },

   -- ref: https://wezfurlong.org/wezterm/multiplexing.html#unix-domains
   unix_domains = {},

   -- ref: https://wezfurlong.org/wezterm/config/lua/WslDomain.html
   wsl_domains = {
      -- {
      --    name = 'WSL:Ubuntu',
      --    distribution = 'Ubuntu',
      --    username = 'kevin',
      --    default_cwd = '/home/kevin',
      --    default_prog = { 'nu', '-l' },
      -- },
   },
}
