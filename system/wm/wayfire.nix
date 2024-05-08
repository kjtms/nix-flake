{ config, lib, pkgs, ... }:

{
  # import wayland config
  imports = [
    ./wayland.nix
  ];
  security = {

    pam.services.login.enableGnomeKeyring = true;
  };

    services.gnome.gnome-keyring.enable = true;

    programs = {
      wayfire.enable = true;
      wayfire.plugins = with pkgs.wayfirePlugins; [
        wcm
        wf-shell
        wayfire-plugins-extra
      ];
      xwayland.enable = true;

    };
  }
