{
  config,
  modules,
  pkgs,
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
    iwd
  ];

  networking.hostName = "finix";

  services = {
    polkit.enable = true;
    sysklogd.enable = true;
    udev.enable = true;
    dhcpcd.enable = true;
    iwd.enable = true;
    getty.enable = true;
    dbus.enable = true;
    seatd.enable = true;
  };

  users.users."ari" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "input" "render" "audio" "pipewire" config.services.seatd.group ];
  };
}
