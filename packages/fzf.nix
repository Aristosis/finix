{
  fzf,
  makeWrapper,
  symlinkJoin,
}:
symlinkJoin {
  name = "fzf-wrapped";
  paths = [ fzf ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/fzf \
      --add-flags "--color=bg:-1" \
      --add-flags "--color=bg+:-1" \
      --add-flags "--color=pointer:#ffc0cb" \
      --add-flags "--color=marker:#ffa500" \
      --add-flags "--color=hl+:#00ffff" \
      --add-flags "--color=hl:#00ffff" \
      --add-flags "--color=info:#b2b2b2" \
      --add-flags "--color=prompt:#ff0000" \
      --add-flags "--gutter=\" \""
  '';
  meta.mainProgram = "fzf";
}
