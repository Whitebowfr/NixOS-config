{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  dotfiles = "${config.home.homeDirectory}/NixOS-config/customisation";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  home.stateVersion = "26.05";

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "default-web-browser" = [ "librewolf.desktop" ];
      "text/html" = [ "librewolf.desktop" ];
      "x-scheme-handler/http" = [ "librewolf.desktop" ];
      "x-scheme-handler/https" = [ "librewolf.desktop" ];
      "x-scheme-handler/about" = [ "librewolf.desktop" ];
      "x-scheme-handler/unknown" = [ "librewolf.desktop" ];
      "application/pdf" = [ "librewolf.desktop" ];
      "inode/directory" = [ "thunar.desktop" ];
      "image/jpeg" = [ "loupe.desktop" ];
      "image/png" = [ "loupe.desktop" ];
      "image/heic" = [ "loupe.desktop" ];
    };
  };

  programs.home-manager = {
    enable = true;
  };

  programs.caelestia = {
    enable = true;
    cli.enable = true;
  };

  programs.lazyvim = { 
    enable = true; 
    extras = {
      lang.typescript = {
        enable = true;
        installDependencies = true;
        tsc.enable = true;
        installRuntimeDependencies = true;
      };
        lang.nix.enable = true;
        lang.python = {
          enable = true;
          installDependencies = true;
          installRuntimeDependencies = true;
        };
        lang.go = {
            enable = true;
            installDependencies = true;
            installRuntimeDependencies = true;
          };
        lang.typst = {
        enable = true;
        installDependencies = true;
        installRuntimeDependencies = true;
      };
      };
      extraPackages = with pkgs; [
      nixd
      alejandra
      nodejs
      typescript-go
      ];


      treesitterParsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      templ
      go
      gomod 
      gowork
      json5
      javascript
      gosum
      css
      ];
  };

  xdg.configFile."caelestia"={
    source = create_symlink "${dotfiles}/caelestia";
    force = true;
    recursive = true;
  };

  xdg.configFile."hypr" = {
    source = create_symlink "${dotfiles}/hypr";
    force = true;
    recursive = true;
  };

  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  systemd.user.services.caelestia.Service.Environment = [
    "QT_QPA_PLATFORMTHEME=gtk3"
  ];

  services.nextcloud-client = {
    enable = false;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };

    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
	gtk-font-name = "JetBrains Nerd Font Regular 10";
      };
    };
  };

  home.packages = [
    pkgs.papirus-icon-theme
    pkgs.adwaita-icon-theme
    pkgs.hicolor-icon-theme
  ];
}
