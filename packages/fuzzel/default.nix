{
  fuzzel,
  makeWrapper,
  symlinkJoin,
}:
symlinkJoin {
  name = "fuzzel-wrapped";
  paths = [ fuzzel ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/fuzzel \
      --add-flags "--config=${./fuzzel.ini}"
  '';
  meta.mainProgram = "fuzzel";
}
