{
  description = "Whitebow's NixOS + Hyprland";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    nixos-grub-themes.url = "github:jeslie0/nixos-grub-themes";

     quickshell = {
        url = "git+https://git.outfoxxed.me/outfoxxed/quickshell?rev=a1a150fab00a93ea983aaca5df55304bc837f51b";
        inputs.nixpkgs.follows = "nixpkgs";
      };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      specialArgs = {inherit inputs;};
      system = "x86_64-linux";
      host = "ShrekPC";
      username = "whitebow";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };
    in
    {
      nixosConfigurations = {
        "${host}" = nixpkgs.lib.nixosSystem rec {
          specialArgs = {
            inherit system;
            inherit inputs;
            inherit username;
            inherit host;
          };
          system = "x86_64-linux";

          modules = [
            ./configuration/system.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = specialArgs;
              home-manager.backupFileExtension = "bkpp";

              home-manager.users.whitebow = {inputs, ...}: {
                imports = [
                  inputs.caelestia-shell.homeManagerModules.default
                  ./configuration/home.nix
                ];
              };
            }
          ];
        };
      };
    };
}
