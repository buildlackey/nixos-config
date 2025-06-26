{ config, pkgs, lib,  ... }:

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

  boot.kernel.sysctl."fs.inotify.max_user_watches" = 524288;

  time.timeZone = "America/Los_Angeles";

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
  services.printing.browsing = true;
  services.printing.listenAddresses = [ "localhost:631" ];

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplip ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.resolved.enable = false;

  # ✅ NSS config for .local resolution
  system.nssModules = [ pkgs.nssmdns ];
  environment.extraOutputsToInstall = [ "out" "lib" ];

  # ✅ PipeWire + PulseAudio compatibility
  sound.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ✅ ALSA softvol config to limit volume to safe levels
  environment.etc."asound.conf".text = ''
    pcm.!default {
        type plug
        slave.pcm "softvol"
    }

    pcm.softvol {
        type softvol
        slave {
            pcm "hw:0"
        }
        control {
            name "Master"
            card 0
        }
        max_dB -10.0
    }
  '';

  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "trezor-udev-rules";
      destination = "/etc/udev/rules.d/51-trezor.rules";
      text = builtins.readFile (pkgs.fetchurl {
        url = "https://data.trezor.io/udev/51-trezor.rules";
        sha256 = "0vlxif89nsqpbnbz1vwfgpl1zayzmq87gw1snskn0qns6x2rpczk";
      });
    })
  ];

  environment.systemPackages = with pkgs; [
    alsa-utils

    temurin-bin-17
    jetbrains.idea-community

    zip
    unzip

    gnome.nautilus

    dejavu_fonts
    liberation_ttf
    freefont_ttf
    nerdfonts
    ubuntu_font_family

    libsForQt5.kolourpaint
    kdePackages.breeze-icons
    kdePackages.kconfig
    kdePackages.kiconthemes
    kdePackages.kio

    gnome.adwaita-icon-theme
    mate.mate-icon-theme

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

    mpv
    vim
    (vim_configurable.overrideAttrs (old: { gui = "gtk"; }))

    nssmdns
  ];

  environment.variables = {
    JAVA_HOME = "${pkgs.temurin-bin-17}";
  };

  systemd.services."systemd-tmpfiles-clean".startAt = "daily";

  services.journald = {
    storage = "volatile";
    rateLimitInterval = "30s";
    rateLimitBurst = 1000;
  };

  system.stateVersion = "24.05";
}

