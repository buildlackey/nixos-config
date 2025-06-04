{
  description = "Chris's NixOS Configuration with Flake Modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    insynch.url = "path:./flakes/insynch";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, insynch, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./configuration.nix
        insynch.nixosModules.default

        # ✅ Home Manager system module
        home-manager.nixosModules.home-manager

        # ✅ Connect external home.nix for user chris
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.chris = import ./home/chris/home.nix;
        }
      ];
    };
  };
}

