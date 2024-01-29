{ config, lib, pkgs, font, ... }:

{
  programs.swaylock = {
    package = pkgs.swaylock-effects;
    settings = {
      clock = true;
      color = "00000000";
      image = config.stylix.image;
      effect-blur = "5x10";
      font = font;
      show-failed-attempts = true;
      indicator = true;
      indicator-radius = 200;
      indicator-thickness = 20;
      line-color = config.lib.stylix.colors.base00;
      ring-color = config.lib.stylix.colors.base08;
      inside-color = config.lib.stylix.colors.base00;
      key-hl-color = config.lib.stylix.colors.base00;
      separator-color = "00000000";
      text-color = config.lib.stylix.colors.base05;
      text-caps-lock-color = "";
      line-ver-color = config.lib.stylix.colors.base0E;
      ring-ver-color = config.lib.stylix.colors.base0E;
      inside-ver-color = config.lib.stylix.colors.base00;
      text-ver-color = config.lib.stylix.colors.base05;
      ring-wrong-color = config.lib.stylix.colors.base08;
      text-wrong-color = config.lib.stylix.colors.base08;
      inside-wrong-color = config.lib.stylix.colors.base00;
      inside-clear-color = config.lib.stylix.colors.base00;
      text-clear-color = config.lib.stylix.colors.base05;
      ring-clear-color = config.lib.stylix.colors.base05;
      line-clear-color = config.lib.stylix.colors.base00;
      line-wrong-color = config.lib.stylix.colors.base00;
      bs-hl-color = config.lib.stylix.colors.base0E;
      line-uses-ring = false;
      grace = 4;
      grace-no-mouse = false;
      grace-no-touch = false;
      timestr = "%I:%M%p";
      datestr = "%a, %d %b-%y";
      fade-in = 1;
      ignore-empty-password = true;
    };
  };
}
