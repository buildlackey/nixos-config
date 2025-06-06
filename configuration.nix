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
    firefox
    google-chrome
    curl
    wget
    git
    vim
    jq
    openssh
    xclip
    neofetch
    networkmanagerapplet


    dropbox
    mate.mate-indicator-applet


    docker-compose
    virtualbox

    libsForQt5.kolourpaint
    brasero
    wireshark
    xsane
    lsscsi
    libappindicator-gtk3
    simple-scan
    hplip
    mpv         # ✅ added mpv
  ];

  systemd.services.docker.enable = true;

  system.stateVersion = "24.05";
}

