{
  modules,
  pkgs,
  ...
}:
{
  imports = with modules; [
    nix-daemon
    limine
    sudo
    zsh
    bash
  ];

  finit.runlevel = 3;
  time.timeZone = "Asia/Kolkata";
  hardware.console.keyMap = "colemak";

  boot = {
    kernelPackages = pkgs.linuxPackages;
    loader.efi.canTouchEfiVariables = true;
  };

  i18n = {
    defaultLocale = "en_IN";
    extraLocaleSettings = {
      LC_MONETARY = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
    };
  };

  services.nix-daemon = {
    enable = true;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      substituters = [ "https://finix.cachix.org" ];
      trusted-public-keys = [ "finix.cachix.org-1:0ejikHDeCp0UErsduUUHcg9IJczY2/h2e5132Z/As/c=" ];
    };
  };

  programs = {
    limine = {
      enable = true;
      settings.editor_enabled = true; # NOTE: Disable on systems that need security.
    };
    sudo.enable = true;
    bash.enable = true;
    zsh.enable = true;
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    iputils
    iproute2
    nixos-rebuild-ng
  ];
}
