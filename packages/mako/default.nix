{
  mako,
  makeWrapper,
  symlinkJoin,
}:
symlinkJoin {
  name = "mako-wrapped";
  paths = [ mako ];
  nativeBuildInputs = [ makeWrapper ];
  passthru = mako.passthru;
  postBuild = ''
    wrapProgram $out/bin/mako \
      --add-flags "-c ${./config}"
  '';
  meta.mainProgram = "mako";
}
