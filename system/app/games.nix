{ config, lib, pkgs, ... }:

{
  hardware.opengl.driSupport32Bit = true;

  environment.systemPackages = with pkgs; [
    steam
    prismlauncher
    lutris
    heroic
  ];
}
