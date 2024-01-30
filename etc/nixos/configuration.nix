{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";

  # Virt-Manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    libinput = {
      enable = true;
      mouse = {
        accelProfile = "flat";
      };
    };
  };

  # Enable Dwm
  services.xserver.windowManager.dwm = {
    enable = true;
    #patches = [ /home/rileyl/suckless/dwm/patches ];
    package = pkgs.dwm.overrideAttrs {
      src = /home/rileyl/suckless/dwm;
    };
  };

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Enable and Start emacs daemon
  services.emacs = {
    enable = true;
    package = pkgs.emacs;  
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable Bluetooth and Start on Boot
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Enable Flakes And Nix Commands
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.rileyl = {
    isNormalUser = true;
    description = "Riley Lucas";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "dialout" ];
    packages = with pkgs; [
      firefox
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable Dconf
  programs.dconf.enable = true;

  # Enable Steam 
  programs.steam = {
  	enable = true;
  	remotePlay.openFirewall = true;
  	dedicatedServer.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    alacritty
    brave btop bibata-cursors
    discord dunst dmenu
    dracula-icon-theme dracula-theme
    fd
    gparted gruvbox-gtk-theme gruvbox-dark-icons-gtk git gimp gnumake gnome.adwaita-icon-theme
    htop
    kitty
    libsForQt5.kdenlive libsForQt5.qt5ct lsd lxappearance
    mpv
    newsboat neofetch neovim nitrogen
    pavucontrol papirus-icon-theme picom prismlauncher
    qemu_full
    rofi rose-pine-icon-theme ripgrep
    tela-circle-icon-theme thonny
    vim
    (slstatus.overrideAttrs (_:{ src = /home/rileyl/suckless/slstatus;}))
    (st.overrideAttrs (oldAttrs: rec {
      patches = [
        /home/rileyl/suckless/st/patches/st-gruvbox-dark-0.8.5.diff
        /home/rileyl/suckless/st/patches/st-alpha-20220206-0.8.5.diff
      ];
      configFile = writeText "config.def.h" (builtins.readFile /home/rileyl/suckless/st/config.h);
    }))
    starship sxhkd slock
    yt-dlp
    xfce.thunar
    steam st sweet
    obs-studio
  ];
  
  system.stateVersion = "23.11";

}
