{ config, pkgs, ... }:

{
  # OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      amdvlk
      mesa.drivers
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
      driversi686Linux.mesa
    ];
  };
  environment.systemPackages = with pkgs; [
    clinfo
    mesa
  ];
}
