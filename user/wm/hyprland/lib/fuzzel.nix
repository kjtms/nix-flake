{ config, lib, pkgs, userSettings, ... }:

{
  programs.fuzzel.enable = true;
  programs.fuzzel.settings = {
    main = {
      font = userSettings.font + ":size=15";
      dpi-aware = "no";
      show-actions = "yes";
      terminal = "${pkgs.alacritty}/bin/alacritty";
    };
    colors = {
      background = config.lib.stylix.colors.base00 + "bf";
      text = config.lib.stylix.colors.base07 + "ff";
      match = config.lib.stylix.colors.base0B + "ff";
      selection = config.lib.stylix.colors.base07 + "ff";
      selection-text = config.lib.stylix.colors.base00 + "ff";
      selection-match = config.lib.stylix.colors.base0B + "ff";
      border = config.lib.stylix.colors.base0E + "ff";
    };
    border = {
      width = 3;
      radius = 7;
    };
  };

}
