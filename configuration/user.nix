{
  pkgs,
  username,
  lib,
  config,
  inputs,
  ...
}:
let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = config.nixpkgs.config.allowUnfree or false;
  };
in
{
  imports = [
    inputs.spicetify-nix.nixosModules.default
    ./orcaslicer.nix
  ];

  users.groups.kvm.members = [ "${username}" ];
  #users.groups.libvirtd.members = [ "${username}" ];

  #virtualisation.libvirtd = {
  #  enable = true;
  #};

  virtualisation.docker = {
    enable = true;
  };

  users = {
    mutableUsers = true;
    users."${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "Whitebowfr";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
        "video"
        "input"
        "audio"
        "dialout"
        "usb"
        "wireshark"
        "plugdev"
        "gamemode"
	"docker"
      ];

      packages = with pkgs; [
        thunderbird
        vscode
        libreoffice
        git
        krabby
        webcord #discord
        gh
        ungoogled-chromium
        qucs-s
        steam-run
        digital
        heroic
        blender
        wineWow64Packages.waylandFull
        winetricks
       	art
       	freecad
       	prismlauncher
       	nodejs_24
       	unstable.kicad
       	zed-editor
      	kiwix
	krita
      ];
    };
  };



  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      #xdg-desktop-portal-hyprland
    ];
    config.common.default = ["hyprland" "gtk" ];
  };

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  programs = {
    nix-ld.enable = true;
    gamemode.enable = true;
    gpu-screen-recorder.enable = true;
    java.enable = true;
    spicetify =
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      in
      {
        enable = true;
        theme = spicePkgs.themes.catppuccin;
        colorScheme = "mocha";
        enabledExtensions = with spicePkgs.extensions; [
          shuffle
          fullAppDisplay
          betterGenres
          adblock
          aiBandBlocker
        ];
        enabledCustomApps = with spicePkgs.apps; [
          newReleases
          lyricsPlus
        ];
      };

    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      gamescopeSession.enable = false; # Temporary issue fix
    };

    gamescope = {
      enable = false;
      capSysNice = false;
    };

    git.enable = true;
    nm-applet.indicator = true;

    thunar = {
      enable = true;
      plugins = with pkgs; [ thunar-archive-plugin thunar-volman ];
    };
    xwayland.enable = true;

    dconf.enable = true;
    dconf.profiles.user.databases = [{
      settings."org/gnome/desktop/interface" = {
        gtk-theme = "Adwaita";
        icon-theme = "Flat-Remix-Red-Dark";
      };
    }];
    seahorse.enable = true;
    fuse.userAllowOther = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
