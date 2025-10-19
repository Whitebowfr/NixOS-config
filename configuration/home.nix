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
    theme = /home/whitebow/.config/rofi/themes/KooL_style-5.rasi;
    font = "JetBrainsMono Nerd Font SemiBold 13";
    plugins = with pkgs; [
      (rofi-calc.override { rofi-unwrapped = rofi-wayland-unwrapped; })
    ];
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
      exec-once = $HOME/.config/hypr/initial-boot.sh

      # Sourcing external config files
      $configs = $HOME/.config/hypr/configs # Default Configs directory path

      source=$configs/Keybinds.conf # Pre-configured keybinds

      # ## This is where you want to start tinkering 
      $UserConfigs = $HOME/.config/hypr/UserConfigs # User Configs directory path

      source= $UserConfigs/Startup_Apps.conf # put your start-up packages on this file

      source= $UserConfigs/ENVariables.conf # Environment variables to load

      #source= $UserConfigs/Monitors.conf # Its all about your monitor config (old dots) will remove on push t>
      #source= $UserConfigs/WorkspaceRules.conf # Hyprland workspaces (old dots) will remove on push to main

      source= $UserConfigs/Laptops.conf # For laptop related

      source= $UserConfigs/LaptopDisplay.conf # Laptop display related. You need to read the comment on this f>

      source= $UserConfigs/WindowRules.conf # all about Hyprland Window Rules and Layer Rules

      source= $UserConfigs/UserDecorations.conf # Decorations config file

      source= $UserConfigs/UserAnimations.conf # Animation config file

      source= $UserConfigs/UserKeybinds.conf # Put your own keybinds here

      source= $UserConfigs/UserSettings.conf # Main Hyprland Settings.

      source= $UserConfigs/01-UserDefaults.conf # settings for User defaults apps

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
