{
  waybar,
  makeWrapper,
  symlinkJoin,
  ... # trust me you need this.
}:
symlinkJoin {
  name = "waybar-wrapped";
  paths = [ waybar ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/waybar \
      --add-flags "--config=${./config.jsonc}" \
      --add-flags "--style=${./style.css}"
  '';
  meta.mainProgram = "waybar";
}
