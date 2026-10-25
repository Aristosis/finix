{
  description = "flake.nixu";

  inputs = {
     nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
  };

  outputs = {}:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.;
  in {
     devShells.default = {
        packages = with pkgs; [
          ahehee
        ];

        shellHook = ''
          zsh
        '';
     };
  };
}
