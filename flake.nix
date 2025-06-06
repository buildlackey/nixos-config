{
  description = "Chris's NixOS Configuration with Flake Modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    insynch.url = "path:./flakes/insynch";
  };

  outputs = { self, nixpkgs, home-manager, insynch, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix

        # ✅ Enable Home Manager inside the system configuration
        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.chris = import ./home.nix;
        }

        # Optional module: uncomment if needed
        # insynch.nixosModules.default
      ];
    };
  };
}

