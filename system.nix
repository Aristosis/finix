let
  sources = import ./lon.nix;

  pkgs = import sources.nixpkgs {
    config.allowUnfree = true;
    flake.source = sources.nixpkgs;
  };

  flake-compat = import sources.flake-compat;
  finix = import sources.finix;
  hjem = import sources.hjem { };
  quadra = (flake-compat { src = sources.Quadra; }).defaultNix;

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
        quadra
        ;
    };
    modules = [
      { nixpkgs.pkgs = pkgs; }
      ./hosts
      ./hosts/ari-nuggetbox
    ];
  };
}
