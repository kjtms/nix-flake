{ config, lib, pkgs, pkgs-stable, ... }:

{
  hardware.opengl.driSupport32Bit = true;
  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    steam
    prismlauncher
    heroic
    cartridges
    mangohud
    gamescope
  ] ++ (with pkgs-stable; [
    (lutris.override {
    # extraLibraries = [  ];
      extraPkgs = pkgs: [
        gnome.adwaita-icon-theme
      ];
    })
  ]);
}
