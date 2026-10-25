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


  # "${self}/config/nvim" - string
  # self + "/config/nvim" - path
  hjem.users.ari = {
    user = "ari";
    xdg.config.files = {
      "nvim".source = "${self}/config/nvim";
      "fuzzel".source = "${self}/config/fuzzel";
      "kitty".source = "${self}/config/kitty";
      "mako".source = "${self}/config/mako";
      "niri".source = "${self}/config/niri";
      "waybar".source = "${self}/config/waybar";
    };
    files.".zshrc".source = "${self}/config/zsh/zshrc";
  };

  services.rtkit = {
    enable = true;
    extraGroups = [ config.services.seatd.group ];
  };

  services.ly = {
    enable = true;
    settings.session_log = ".local/state/ly-session.log";
  };

  programs = {
    pipewire.enable = true;
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

  programs.modprobe.blacklist = [ "amdgpu" ];

  services.nix-daemon.settings = {
    substituters = [ "https://cache.nixos-cuda.org" ];
    trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
  };

  environment.systemPackages = with pkgs; [
    ripgrep
    fd
    zoxide

    firefox
    obsidian
    syncthing
    steam-run
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
