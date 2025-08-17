{
  description = "Chris's NixOS Configuration with Flake Modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    insynch.url = "path:./flakes/insynch";
  };

  outputs = { self, nixpkgs, home-manager, insynch, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./configuration.nix
        insynch.nixosModules.default
      ];
    };
  };
}
