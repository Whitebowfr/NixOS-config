# 💫 https://github.com/JaKooLit 💫 #
# Packages and Fonts config including the "programs" options

{ pkgs, inputs, ... }:
let
  python-packages = pkgs.python3.withPackages (
    ps: with ps; [
      requests
      pyquery # needed for hyprland-dots Weather script
    ]
  );

in
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages =
    (with pkgs; [
      bc
    baobab
    btrfs-progs
    clang
    curl
    cpufrequtils
    duf
    findutils
    ffmpeg   
    glib #for gsettings to work
    gsettings-qt
    git
    killall  
    libappindicator
    libnotify
    openssl #required by Rainbow borders
    pciutils
    neovim
    libqalculate
    wget
    xdg-user-dirs
    xdg-utils
    dysk
    protonvpn-gui
    protonvpn-cli
    fastfetch
    (mpv.override {scripts = [mpvScripts.mpris];}) # with tray
    #ranger
    platformio      
    # Hyprland Stuff
    #(ags.overrideAttrs (oldAttrs: { inherit (oldAttrs) pname; version = "1.8.2"; }))
    ags # desktop overview  
    btop
    brightnessctl # for brightness control
    cava
    cliphist
    ghostty
    loupe
    gnome-system-monitor
    grim
    gtk-engine-murrine #for gtk themes
    hypridle
    imagemagick 
    inxi
    jq
    kitty
    libsForQt5.qtstyleplugin-kvantum #kvantum
    networkmanagerapplet
    nwg-displays
    nwg-look
    nvtopPackages.full	 
    pamixer
    pavucontrol
    playerctl
    polkit_gnome
    libsForQt5.qt5ct
    kdePackages.qt6ct
    kdePackages.qtwayland
    kdePackages.qtstyleplugin-kvantum #kvantum
    #rofi-wayland
    #rofi-calc
    slurp
    swappy
    swaynotificationcenter
    swww
    unzip
    wallust
    wl-clipboard
    wlogout
    xarchiver
    yad
    yt-dlp
    #flatpak
    waybar  # if wanted experimental next line
    #(pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];}))
    #inputs.affinity-nix2.packages.x86_64-linux.photo
    #inputs.affinity-nix.packages.x86_64-linux.designer
    tinymist
    wireshark
    librewolf
    gnome-boxes
    dnsmasq
    phodav
    inkscape-with-extensions
    nmap
    wireguard-tools
    teams-for-linux
    hyperhdr
      ledfx
      rofi-wayland
      hyprland-qt-support
    ])
    ++ [
      python-packages
    ];

  # FONTS
  fonts.packages = with pkgs; [
    noto-fonts
    font-awesome
    terminus_font
    roboto
    nerd-fonts.jetbrains-mono # unstable
    nerd-fonts.fira-code # unstable
    nerd-fonts.fantasque-sans-mono # unstable
  ];
}
