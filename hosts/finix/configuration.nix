{
  self,
  config,
  modules,
  localModules,
  pkgs,
  localPkgs,
  ...
}:
{
  imports = with modules;
  [
    ./hardware-configuration.nix
    openssh
    sysklogd
    polkit
    getty # important
    dhcpcd

    niri
    pipewire
    wireplumber
    rtkit
    ly

    (localModules + /niri.nix)
    (localModules + /fonts.nix)
  ];

  networking.hostName = "finix";

  services = {
    polkit.enable = true;
    openssh.enable = true;
    sysklogd.enable = true;
    udev.enable = true;
    dhcpcd.enable = true;
    getty.enable = true;
    dbus.enable = true;
    seatd.enable = true;
    sessiond.enable = true;
  };

  users.users."ari" = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "input"
      "render"
      "audio"
      "pipewire"
      "dialout"
      config.services.seatd.group
    ];
    shell = pkgs.zsh;
  };


  # "${self}/config/nvim" - string
  # self + "/config/nvim" - path
  hjem.users.ari = {
    user = "ari";
    xdg.config.files =
    let
    gtkrc = ''
      [Settings]
      gtk-application-prefer-dark-theme=true
    '';
    in
    {
      "nvim".source = "${self}/config/nvim";
      "fuzzel".source = "${self}/config/fuzzel";
      "kitty".source = "${self}/config/kitty";
      "mako".source = "${self}/config/mako";
      "niri".source = "${self}/config/niri";
      "waybar".source = "${self}/config/waybar";
      "gtk-3.0/settings.ini".text = gtkrc;
      "gtk-4.0/settings.ini".text = gtkrc;
      "user-dirs.dirs".text = ''
        XDG_DESKTOP_DIR="$HOME/media/hdd/Desktop"
        XDG_DOWNLOAD_DIR="$HOME/media/downloads"
        XDG_DOCUMENTS_DIR="$HOME/media/hdd/documents"
        XDG_MUSIC_DIR="$HOME/media/hdd/music"
        XDG_PICTURES_DIR="$HOME/media/hdd/pictures"
        XDG_VIDEOS_DIR="$HOME/media/hdd/videos"
        XDG_PROJECTS_DIR="$HOME/media/projects"
        XDG_TEMPLATES_DIR="/dev/null"
        XDG_PUBLICSHARE_DIR="/dev/null"
      '';
    };
    files.".zshrc".text = (builtins.readFile "${self}/config/zsh/zshrc") +
    ''
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
    '';
  };

  services = {
    rtkit = {
      enable = true;
      extraGroups = [ config.services.seatd.group ];
    };

    ly = {
      enable = true;
      settings.session_log = ".local/state/ly-session.log";
    };
  };


  programs = {
    zsh.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
    };
    wireplumber.enable = true;
  };


  hardware = {
    graphics.enable = true;
    graphics.enable32Bit = true;
    nvidia = {
      enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
      modesetting.enable = true;
    };
  };

  services.nix-daemon.settings = {
    substituters = [ "https://cache.nixos-cuda.org" ];
    trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
  };

  environment.systemPackages = with pkgs; [
    localPkgs.fzf-wrapped
    ripgrep
    fd
    zoxide
    direnv
    nix-direnv
    p7zip

    # nix cli
    nix-du
    nix-diff
    nix-tree

    (obs-studio.override {
        cudaSupport = true;
    })
    heroic
    firefox
    obsidian
    syncthing
    mpv
    gnutar
  ];

  xdg = {
    autostart.enable = true;
    icons.enable = true;
    mime.enable = true;
    portal.enable = true;
    portal.portals = with pkgs;
    [
      oo7-portal
    ];
  };
}
