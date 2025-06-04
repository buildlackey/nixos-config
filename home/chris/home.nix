{ config, pkgs, ... }:

{
  home.username = "chris";
  home.homeDirectory = "/home/chris";
  home.stateVersion = "24.05";

  # Enable Bash with sane defaults
  programs.bash.enable = true;

  # Git global configuration
  programs.git = {
    enable = true;
    userName = "chris";
    userEmail = "chris@buildlackey.com";
    extraConfig = {
      core.excludesfile = "/etc/nixos/.gitignore";
    };
  };


  # Packages you want always available
  home.packages = with pkgs; [
    neofetch
    htop
    xclip
    python3
    python3Packages.venvShellHook
  ];
}

