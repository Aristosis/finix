{
  config,
  modules,
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
    gnome-keyring

    # sessiond
    niri
    pipewire
    wireplumber
    rtkit
    ly
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

  programs.zsh.enable = true;

  users.users."ari" = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "input"
      "render"
      "audio"
      "pipewire"
      config.services.seatd.group
    ];
    shell = pkgs.zsh;
  };

  services.rtkit = {
    enable = true;
    extraGroups = [ config.services.seatd.group ];
  };

  services.ly = {
    enable = true;
    settings.session_log = ".local/state/ly-session.log";
  };

  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Iosevka" ];
      };
    };
    packages = with pkgs; [
      inter
      iosevka
      nerd-fonts.symbols-only
    ];
  };

  programs = {
    gnome-keyring.enable = true;
    pipewire.enable = true;
    wireplumber.enable = true;

    niri = {
      enable = true;
      package = localPkgs.niri-wrapped;
    };
  };

  environment.etc."xdg/xdg-desktop-portal/niri-portals.conf".text = ''
    [preferred]
    default=gnome;gtk;
    org.freedesktop.impl.portal.FileChooser=gtk;
    org.freedesktop.impl.portal.Secret=oo7-portal;
  '';

  environment.etc."xdg/xdg-desktop-portal-wlr/config".text = ''
    [screencast]
    chooser_type=dmenu
    chooser_cmd=fuzzel --dmenu --prompt="Share: "
  '';

  hardware = {
    graphics.enable = true;
    graphics.enable32Bit = true;
    nvidia = {
      enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
      modesetting.enable = true;
    };
  };

  programs.modprobe.blacklist = [ "amdgpu" ];

  services.nix-daemon.settings = {
    substituters = [ "https://cache.nixos-cuda.org" ];
    trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
  };

  environment.systemPackages = with pkgs; [
    localPkgs.fuzzel-character-picker
    localPkgs.kitty-wrapped
    localPkgs.fuzzel-wrapped
    localPkgs.mako-wrapped
    localPkgs.kitty-wrapped
    localPkgs.waybar-wrapped
    localPkgs.fzf-wrapped

    ripgrep
    fd
    zoxide

    swaybg
    banana-cursor
    wl-clipboard
    cliphist
    xwayland-satellite
    firefox
    obsidian
    syncthing
  ];

  xdg = {
    autostart.enable = true;
    icons.enable = true;
    mime.enable = true;
    portal = {
      enable = true;
      portals = with pkgs; [
        xdg-desktop-portal-gnome
        oo7-portal
        xdg-desktop-portal-gtk
      ];
    };
  };
}
