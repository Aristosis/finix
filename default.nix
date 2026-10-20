let
  sources = import ./lon.nix;
  finix = import sources.finix;
  pkgs = import sources.nixpkgs {
    config.allowUnfree = true;
  };
  localPkgs = import ./packages { inherit pkgs; };
in
{
  desktop = finix.lib.finixSystem {
    inherit (pkgs) lib;
    specialArgs = { inherit localPkgs; inherit pkgs; };
    modules = [
      ./hosts/default.nix
      ./hosts/finix/configuration.nix
    ];
  };
}
