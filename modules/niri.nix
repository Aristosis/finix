{
  pkgs,
  localPkgs,
  ...
}:
{
  programs.niri = {
    enable = true;
    package = localPkgs.niri-wrapped;
  };

  environment.systemPackages = with pkgs; with localPkgs;
  [
    fuzzel-character-picker
    fuzzel-wrapped
    kitty-wrapped
    mako-wrapped
    waybar-wrapped

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
