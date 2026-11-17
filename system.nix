let
  sources = import ./lon.nix;
  finix = import sources.finix;
  pkgs = import sources.nixpkgs {
    config.allowUnfree = true;
    flake.source = sources.nixpkgs;
  };
  hjem = import sources.hjem { };
  localPkgs = import ./packages { inherit pkgs; };
  localModules = ./modules;
  self = toString ./.;
in
{
  ari-nuggetbox = finix.lib.finixSystem {
    inherit (pkgs) lib;
    specialArgs = {
      inherit
        self
        localPkgs
        localModules
        sources
        hjem
        ;
    };
    modules = [
      { nixpkgs.pkgs = pkgs; }
      ./hosts
      ./hosts/ari-nuggetbox
    ];
  };
}
