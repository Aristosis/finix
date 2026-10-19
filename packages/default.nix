{
  pkgs,
}:
rec {
  fzf-wrapped = pkgs.callPackage ./fzf.nix { };
  kitty-wrapped = pkgs.callPackage ./kitty { };
  bat-wrapped = pkgs.callPackage ./bat.nix { };
  fuzzel-wrapped = pkgs.callPackage ./fuzzel { };
  gamering = pkgs.callPackage ./umu-launcher-wrapped.nix { };
  fuzzel-character-picker = pkgs.callPackage ./fuzzel-character-picker { inherit fuzzel-wrapped; };
  niri-wrapped = pkgs.callPackage ./niri { };
  mako-wrapped = pkgs.callPackage ./mako { };
  waybar-wrapped = pkgs.callPackage ./waybar { inherit pkgs; };
  zsh-wrapped = pkgs.callPackage ./zsh { };
}
