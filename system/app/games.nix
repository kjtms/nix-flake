{ config, lib, pkgs, pkgs-stable, ... }:

{
  hardware.opengl.driSupport32Bit = true;

  environment.systemPackages = with pkgs; [
    steam
    prismlauncher
    heroic
    mangohud
    gamescope
  ] ++ (with pkgs-stable; [
    lutris
  ]);
}
