{ config, lib, pkgs, ... }:

{
  services.mopidy.enable = true;

  home.packages = with pkgs; [
    mopidy-mpd
    mopidy-iris
  ];
}
