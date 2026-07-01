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
#    package = inputs.caelestia-shell.packages.x86_64-linux.with-cli.override {xkeyboard-config = pkgs.xkeyboard_config;};
    package = inputs.caelestia-shell.packages.x86_64-linux.with-cli;
    #settings = import ../customisation/caelestia.nix;
    cli.enable = true;
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

  xdg.configFile."nvim" = {
    source = create_symlink "${dotfiles}/nvim";
    force = true;
    recursive = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  systemd.user.services.caelestia.Service.Environment = [
    "QT_QPA_PLATFORMTHEME=gtk3"
  ];

/*  wayland.windowManager.hyprland = {
    enable = true;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    #portalPackage = null;
    #package = null;
    xwayland.enable = true;
    settings = {
      debug.disable_logs = false;
    };
    extraConfig = ''
$config = $HOME/.config/hypr
source=$config/settings.conf
source=$config/keybinds.conf
source=$config/startup.conf
source=$config/monitors.conf
source=$config/shortcuts.conf
#require(".keybinds")
#require(".shortcuts")
#require(".startup")
#require(".monitors")
#require(".windowRules")
#require(".settings")

#hl.env("AQ_DRM_DEVICES", "/dev/dri/card0:/dev/dri/card1")
#hl.config({
#    debug = {
#        disable_logs = false,
#    },
#})
'';
  };*/

  services.nextcloud-client = {
    enable = true;
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
