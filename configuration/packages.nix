# 💫 https://github.com/JaKooLit 💫 #
# Packages and Fonts config including the "programs" options

{ pkgs, inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages =
    (with pkgs; [
      xinit
      swappy
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
      libqalculate
      wget
      xdg-user-dirs
      xdg-utils
      dysk
      proton-vpn
      proton-vpn-cli
      fastfetch
      (mpv.override {scripts = [mpvScripts.mpris];}) # with tray
      btop
      brightnessctl # for brightness control
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
      yt-dlp
      tinymist
      dnsmasq
      phodav
      nmap
      wireguard-tools
      hyperhdr
      ledfx
      hyprland-qt-support
      dig
      clang-tools
      jdt-language-server
      typescript-language-server
      gsettings-desktop-schemas
      xfce4-exo
      mousepad
      swappy
      openconnect
      alsa-utils
    ]);

  # FONTS
  fonts.packages = with pkgs; [
    noto-fonts
    font-awesome
    terminus_font
    roboto
    nerd-fonts.jetbrains-mono
    dejavu_fonts
    liberation_ttf
  ];

  fonts.fontconfig = {
    enable = true;
    antialias = true;
  };
}
