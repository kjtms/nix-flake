{ pkgs, ... }:

{
  # OpenGL
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
    rocmPackages.clr.icd
    ];
  };
  environment.systemPackages = with pkgs; [
    gpu-viewer
  ];
}
