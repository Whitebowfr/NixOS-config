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
    };
  };
  programs.home-manager.enable = true;

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = "${config.home.homeDirectory}/.config/rofi/themes/KooL_style-5.rasi";
    font = "JetBrainsMono Nerd Font SemiBold 13";
    plugins = with pkgs; [
      (rofi-calc.override { rofi-unwrapped = rofi-wayland-unwrapped; })
    ];
  };

  programs.caelestia = {
    enable = true;
    package = inputs.caelestia-shell.packages.x86_64-linux.with-cli.override {xkeyboard-config = pkgs.xkeyboard_config;}; 
    settings = import ../customisation/caelestia.nix;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    #	plugins = [
    #          inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
    #        ];
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    settings = {
      debug.disable_logs = false;
      #plugin = {
      #  overview = {
      #    reverse_swipe = true;
      #  };
      #};
    };
    extraConfig = ''

      source=$HOME/.config/hypr/keybinds.conf 
      source=$HOME/.config/hypr/shortcuts.conf 
      source=$HOME/.config/hypr/startup.conf 
      source=$HOME/.config/hypr/monitors.conf 
      source=$HOME/.config/hypr/windowRules.conf 
      source=$HOME/.config/hypr/settings.conf 


      # nwg-displays
      source= $HOME/.config/hypr/monitors.conf
      source= $HOME/.config/hypr/workspaces.conf

      exec-once = echo 0018:04F3:2F2C.0002 | sudo tee /sys/bus/hid/drivers/hid-multitouch/unbind
      env = AQ_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1
      	'';
  };


  home.packages = [
    pkgs.hello
    pkgs.hyprlandPlugins.hyprexpo
  ];
}
