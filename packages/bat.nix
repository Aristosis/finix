{
  bat,
  makeWrapper,
  symlinkJoin,
}:
symlinkJoin {
  name = "bat-wrapped";
  paths = [ bat ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/bat \
      --add-flags "--theme=\"Catppuccin Mocha\""
  '';
  meta.mainProgram = "bat";
}
