{ config, lib, pkgs, ... }:

{
  hardware.opengl.driSupport32Bit = true;
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    steam
    prismlauncher
    lutris
    heroic
  ];
}
