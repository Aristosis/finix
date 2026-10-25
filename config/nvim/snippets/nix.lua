return {
   devShell = {
      prefix = "devshell",
      body = [[
{
  description = "${1:Flake}";

  inputs = {
     nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
  };

  outputs = {}:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
     devShells.default = {
        packages = with pkgs; [
          $2
        ];

        shellHook = ''
          ${3|zsh|}
        '';
     };
  };
}
]]
   },
   shellDotNix = {
      prefix = "shell.nix",
      body = [[
{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
   packages = with pkgs; [
     $1
   ];
}
]]
   }
}
