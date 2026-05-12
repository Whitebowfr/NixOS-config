# 💫 https://github.com/JaKooLit 💫 #
# Packages and Fonts config including the "programs" options

{ pkgs, inputs, ... }:
let
  python-packages = pkgs.python3.withPackages (
    ps: with ps; [
      requests
      pyquery # needed for hyprland-dots Weather script
      pyside6
    ]
  );

in
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages =
    (with pkgs; [
      xorg.xinit
      baobab
      btrfs-progs
      clang
      curl
      cpufrequtils
      duf
      findutils
      ffmpeg   
      file-roller
      git
      killall  
      libappindicator
      libnotify
      pciutils
      neovim
      libqalculate
      wget
      xdg-user-dirs
      xdg-utils
      dysk
      protonvpn-gui
      fastfetch
      (mpv.override {scripts = [mpvScripts.mpris];}) # with tray
      platformio      
      btop
      brightnessctl # for brightness control
      cava
      ghostty
      loupe
      hypridle
      imagemagick 
      libsForQt5.qtstyleplugin-kvantum #kvantum
      networkmanagerapplet
      nwg-displays
      nwg-look
      nvtopPackages.full	 
      pamixer
      pavucontrol
      playerctl
      polkit_gnome
      wlogout
      yad
      yt-dlp
      tinymist
      wireshark
      librewolf
      dnsmasq
      phodav
      inkscape-with-extensions
      nmap
      wireguard-tools
      hyperhdr
      ledfx
      hyprland-qt-support
      dig
      clang-tools
      jdt-language-server
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
    nerd-fonts.jetbrains-mono
  ];
}
