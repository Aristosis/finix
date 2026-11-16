{
  pkgs,
  ...
}:

{
  fonts =
    with pkgs;
    let
      monospace = pkgs.iosevka;
      sansSerif = pkgs.inter;
    in
    {
      enableDefaultPackages = true;
      fontconfig = {
        enable = true;
        defaultFonts = {
          monospace = [ monospace.pname ];
          sansSerif = [ sansSerif.pname ];
        };
      };
      packages = with pkgs; [
        noto-fonts
        monospace
        sansSerif
        nerd-fonts.symbols-only
      ];
    };
}
