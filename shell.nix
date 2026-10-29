{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  packages = with pkgs; [
    statix
    nixfmt
    nixfmt-tree
  ];
}
