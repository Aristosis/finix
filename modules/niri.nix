{
  pkgs,
  localPkgs,
  ...
}:
{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; with localPkgs;
  [
    fuzzel-character-picker
    fuzzel
    kitty
    mako
    waybar
    swaybg
    banana-cursor

    banana-cursor
    cliphist
    swaybg
    wl-clipboard
    xwayland-satellite
  ];

  environment.etc."xdg/xdg-desktop-portal/niri-portals.conf".text = ''
    [preferred]
    default=gnome;gtk;
    org.freedesktop.impl.portal.FileChooser=gtk;
    org.freedesktop.impl.portal.Secret=oo7-portal;
  '';

  xdg = {
    portal = {
      portals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
    };
  };
}
