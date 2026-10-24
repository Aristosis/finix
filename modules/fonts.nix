{
  pkgs,
    ...
}:

{
  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Iosevka" ];
        sans-serif = [ "Inter" ];
      };
    };
    packages = with pkgs; [
      inter
      iosevka
      nerd-fonts.symbols-only
    ];
  };
}
