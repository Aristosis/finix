{
  self,
  config,
  pkgs,
  lib,
  ...
}:
let
  zsh = pkgs.zsh;
in
{
  environment.systemPackages = [ zsh ];
  environment.shells = [
    "/run/current-system/sw${zsh.shellPath}"
    "${zsh}${zsh.shellPath}"
  ];

  environment.etc."profile.d/zsh.sh".text = ''
    if [ -n "''${zsh_VERSION:-}" ] && [ -r /etc/zshrc ]; then
      . /etc/zshrc
    fi
  '';

  environment.etc.zshenv.text = ''
    # /etc/zshenv: system-wide environment configuration for zsh shells.

    if [ -r /etc/profile ]; then
      . /etc/profile
    fi
  '';

  environment.etc.zshrc.text = ''
    # /etc/zshrc: system-wide configuration for interactive zsh shells.

    # We are not always an interactive shell.
    if [ -n "$PS1" ]; then
      if command -v dircolors >/dev/null; then
        eval "$(dircolors -b)"
      fi

      alias ls='ls --color=auto'
    fi
  '';

  hjem.users.ari.files.".zshrc".text =
    (builtins.readFile "${self}/config/zsh/zshrc") + ''
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
  '';
}
