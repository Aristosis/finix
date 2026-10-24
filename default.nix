let
  sources = import ./lon.nix;
  finix = import sources.finix;
  pkgs = import sources.nixpkgs {
    config.allowUnfree = true;
    flake.source = sources.nixpkgs;
  };
  localPkgs = import ./packages { inherit pkgs; };
in
{
  desktop = finix.lib.finixSystem {
    inherit (pkgs) lib;
    specialArgs = { inherit localPkgs sources; };
    modules = [
      { nixpkgs.pkgs = pkgs; }
      ./hosts/default.nix
      ./hosts/finix/configuration.nix
    ];
  };
}
