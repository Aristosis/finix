let
  sources = import ./lon.nix;
  finix = import sources.finix;
  pkgs = import sources.nixpkgs {
    config.allowUnfree = true;
    flake.source = sources.nixpkgs;
  };
  localPkgs = import ./packages { inherit pkgs; };
  localModules = ./modules;
in
{
  desktop = finix.lib.finixSystem {
    inherit (pkgs) lib;
    specialArgs = { inherit sources localPkgs localModules; };
    modules = [
      { nixpkgs.pkgs = pkgs; }
      ./hosts/default.nix
      ./hosts/finix/configuration.nix
    ];
  };
}
