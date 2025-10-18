{
  description = "Whitebow's NixOS + Hyprland";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    hyprland.url = "github:hyprwm/Hyprland";

    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.astal.follows = "astal";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    Hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    nixos-grub-themes.url = "github:jeslie0/nixos-grub-themes";

    outputs =
      {
        self,
        nixpkgs,
        ags,
        astal,
        ...
      }:
      {
        nixosConfigurations = {
          main = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            host = "ShrekPC";
            username = "whitebow";

            modules = [
              ./configuration/system.nix
            ];
          };
        };
      };
  };
}
