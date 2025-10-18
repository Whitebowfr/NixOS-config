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
      baobab
      btrfs-progs # Remove ?
      clang
      curl
      cpufrequtils # Remove ?
      ffmpeg
      glib # for gsettings to work
      gsettings-qt

      git
      libappindicator
      libnotify

      openssl # required by Rainbow borders
      pciutils
      neovim
      libqalculate
      wget
      xdg-user-dirs
      xdg-utils

      protonvpn-gui
      protonvpn-cli # R ?
      fastfetch
      (mpv.override { scripts = [ mpvScripts.mpris ]; })
      platformio

      btop
      brightnessctl # for brightness control
      cava
      cliphist
      ghostty
      loupe
      gnome-system-monitor
      grim
      gtk-engine-murrine # for gtk themes
      hypridle
      imagemagick
      libsForQt5.qtstyleplugin-kvantum # kvantum
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
      kdePackages.qtstyleplugin-kvantum
      slurp
      swappy
      swaynotificationcenter
      unzip
      wallust
      wl-clipboard # Cliphist ?
      wlogout
      xarchiver # Fileroller ?
      yt-dlp
      waybar
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
