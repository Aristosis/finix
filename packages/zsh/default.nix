{
  zsh,
  zsh-syntax-highlighting,
  zsh-fzf-tab,
  makeWrapper,
  symlinkJoin,
  writeTextDir,
}:
let
  zdotdir = writeTextDir "config/.zshrc" ''
    ${builtins.readFile ./zshrc}
    source ${zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source ${zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
  '';
in
symlinkJoin {
  name = "zsh-wrapped";
  paths = [ zsh ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/zsh \
      --set ZDOTDIR "${zdotdir}/config"
  '';
  meta.mainProgram = "zsh";
}
