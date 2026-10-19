{
  kitty,
  makeWrapper,
  symlinkJoin,
}:
symlinkJoin {
  name = "kitty-wrapped";
  paths = [ kitty ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/kitty \
      --add-flags "--config=${./kitty.conf}"
  '';
  meta.mainProgram = "kitty";
}
