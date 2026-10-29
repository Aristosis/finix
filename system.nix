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
  self = builtins.toString ./.;
in
{
  desktop = finix.lib.finixSystem {
    inherit (pkgs) lib;
    specialArgs = {
      inherit
        sources
        localPkgs
        localModules
        self
        ;
    };
    modules = [
      { nixpkgs.pkgs = pkgs; }
      hjem.finixModules.default
      ./hosts/default.nix
      ./hosts/finix/configuration.nix
    ];
  };
}
