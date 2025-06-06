{ config, pkgs, ... }:

{
  home.username = "chris";
  home.homeDirectory = "/home/chris";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    jdk17
    jetbrains.idea-community
  ];

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk17}";
  };
}

