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
  imports = with modules; [
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
    (localModules + /packages.nix)
    (localModules + /zsh.nix)
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
        "direnv".source = "${self}/config/direnv";
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

  # environment.etc."asound.conf".text = ''
  #   ctl.!default {
  #     type hw
  #     card "Generic_1" # Replace Generic_1 with your card name from `aplay -l`
  #   }
  #
  #   pcm.dmixer {
  #     type dmix
  #     ipc_key 1024
  #     ipc_perm 0666
  #     slave {
  #       pcm "hw:Generic_1,0" # Replace Generic_1 with your card name from `aplay -l`
  #       period_size 1024     # Prevent audio cracking on certain cards
  #       buffer_size 4096
  #     }
  #   }
  #
  #   pcm.!default {
  #     type plug
  #     slave.pcm "dmixer"
  #   }
  # '';
  programs = {
    wireplumber.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      settings = {
        "context.exec" = [
          {
            path = "${config.programs.wireplumber.package}/bin/wireplumber";
          }
          {
            path = "${config.programs.pipewire.package}/bin/pipewire-pulse";
          }
        ];
      };
    };
  };

  services.nix-daemon.settings = {
    substituters = [ "https://cache.nixos-cuda.org" ];
    trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
  };

  xdg = {
    autostart.enable = true;
    icons.enable = true;
    mime.enable = true;
    portal.enable = true;
    portal.portals = with pkgs; [
      oo7-portal
    ];
  };
}
