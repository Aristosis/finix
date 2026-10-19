{
  description = "Ari finix nix with dat fast init nixfin";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
    finix.url = "github:finix-community/finix";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      finix,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = system;
	config.allowUnfree = true;
      };
      localPkgs = import ./packages { inherit pkgs; };
    in
    {
      packages.${system} = localPkgs;

      nixosConfigurations."finix" = finix.lib.finixSystem {
        inherit (pkgs) lib; # finix needs this
	specialArgs = { inherit localPkgs; };
        modules = [
	  { nixpkgs.pkgs = pkgs; }
          ./hosts/finix/configuration.nix
          ./hosts/default.nix
        ];
      };
    };
}
