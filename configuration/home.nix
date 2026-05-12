{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  home.stateVersion = "24.11";
  
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
    };
  };
  programs.home-manager = {
    enable = true;
  };

  programs.caelestia = {
    enable = true;
#    package = inputs.caelestia-shell.packages.x86_64-linux.with-cli.override {xkeyboard-config = pkgs.xkeyboard_config;}; 
    package = inputs.caelestia-shell.packages.x86_64-linux.with-cli;
    settings = import ../customisation/caelestia.nix;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  systemd.user.services.caelestia.Service.Environment = [
    "QT_QPA_PLATFORMTHEME=gtk3"
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    settings = {
      debug.disable_logs = false;
    };
    extraConfig = ''

      source=$HOME/.config/hypr/keybinds.conf 
      source=$HOME/.config/hypr/shortcuts.conf 
      source=$HOME/.config/hypr/startup.conf 
      source=$HOME/.config/hypr/monitors.conf 
      source=$HOME/.config/hypr/windowRules.conf 
      source=$HOME/.config/hypr/settings.conf 

      exec-once = echo 0018:04F3:2F2C.0002 | sudo tee /sys/bus/hid/drivers/hid-multitouch/unbind
      env = AQ_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1
      	'';
  };

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
