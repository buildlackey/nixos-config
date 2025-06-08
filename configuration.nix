{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # ✅ Enable nix-command and flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  systemd.tmpfiles.rules = [
   "d /tmp 1777 root root 20d"
  ];

  services.xserver = {
    enable = true;
    desktopManager.mate.enable = true;
    displayManager.lightdm.enable = true;
  };

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  users.groups.chris = {};

  users.users.chris = {
    isNormalUser = true;
    group = "chris";
    extraGroups = [ "wheel" "networkmanager" "docker" "vboxusers" "lp" "scanner" ];
    password = "changeme";
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplip ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    temurin-bin-17    		    # JVM stuff
    jetbrains.idea-community
	
    zip
    unzip

    gnome.nautilus		    # file mgr

    dejavu_fonts		    # mainly for vim
    liberation_ttf
    freefont_ttf
    nerdfonts
    ubuntu_font_family

    libsForQt5.kolourpaint          # next block is kolourpaint specific
    kdePackages.breeze-icons
    kdePackages.kconfig
    kdePackages.kiconthemes
    kdePackages.kio

    gnome.adwaita-icon-theme   # GNOME's full icon set
    mate.mate-icon-theme       # MATE’s classic colorful icons

    python3
    python3Packages.venvShellHook

    firefox
    google-chrome

    curl
    wget

    git
    vim-full
    jq
    openssh
    xclip
    neofetch
    networkmanagerapplet


    dropbox
    mate.mate-indicator-applet

    docker-compose
    virtualbox

    brasero
    wireshark
    xsane
    lsscsi
    libappindicator-gtk3
    simple-scan
    hplip

    mpv                                   # ✅ added media player
    vim
    (vim_configurable.overrideAttrs (old: { gui = "gtk"; }))  # ✅ gVim
  ];

  environment.variables = {
    JAVA_HOME = "${pkgs.temurin-bin-17}";
  };

  systemd.services.docker.enable = true;

  system.stateVersion = "24.05";
}

