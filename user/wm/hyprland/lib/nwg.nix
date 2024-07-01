{ config, lib, pkgs, ... }:

{
  home.file.".config/nwg-dock-hyprland/style.css".text = ''
    window {
      background: rgba('' + config.lib.stylix.colors.base00-rgb-r + ","
    + config.lib.stylix.colors.base00-rgb-g + ","
    + config.lib.stylix.colors.base00-rgb-b + ''
      ,0.0);
            border-radius: 20px;
            padding: 4px;
            margin-left: 4px;
            margin-right: 4px;
            border-style: none;
          }

          #box {
            /* Define attributes of the box surrounding icons here */
            padding: 10px;
            background: rgba('' + config.lib.stylix.colors.base00-rgb-r + ","
    + config.lib.stylix.colors.base00-rgb-g + ","
    + config.lib.stylix.colors.base00-rgb-b + ''
      ,0.55);
            border-radius: 20px;
            padding: 4px;
            margin-left: 4px;
            margin-right: 4px;
            border-style: none;
          }
          button {
            border-radius: 10px;
            padding: 4px;
            margin-left: 4px;
            margin-right: 4px;
            background: rgba('' + config.lib.stylix.colors.base03-rgb-r + ","
    + config.lib.stylix.colors.base03-rgb-g + ","
    + config.lib.stylix.colors.base03-rgb-b + ''
      ,0.55);
            color: #'' + config.lib.stylix.colors.base07 + ''
        ;
              font-size: 12px
            }

            button:hover {
              background: rgba('' + config.lib.stylix.colors.base04-rgb-r + ","
    + config.lib.stylix.colors.base04-rgb-g + ","
    + config.lib.stylix.colors.base04-rgb-b + ''
      ,0.55);
          }

    '';
  home.file.".config/nwg-dock-pinned".text = ''
    nwggrid
    Alacritty
    emacsclientnewframe
    qutebrowser
    brave-browser
    librewolf
    writer
    impress
    calc
    draw
    krita
    pinta
    xournalpp
    obs
    kdenlive
    flstudio
    blender
    openscad
    Cura
    virt-manager
  '';
 home.file.".config/nwg-launchers/nwggrid/style.css".text = ''
    button, label, image {
        background: none;
        border-style: none;
        box-shadow: none;
        color: #'' + config.lib.stylix.colors.base07 + ''
      ;

              font-size: 20px;
          }

          button {
              padding: 5px;
              margin: 5px;
              text-shadow: none;
          }

          button:hover {
              background-color: rgba('' + config.lib.stylix.colors.base07-rgb-r
    + "," + config.lib.stylix.colors.base07-rgb-g + ","
    + config.lib.stylix.colors.base07-rgb-b + "," + ''
      0.15);
          }

          button:focus {
              box-shadow: 0 0 10px;
          }

          button:checked {
              background-color: rgba('' + config.lib.stylix.colors.base07-rgb-r
    + "," + config.lib.stylix.colors.base07-rgb-g + ","
    + config.lib.stylix.colors.base07-rgb-b + "," + ''
      0.15);
          }

          #searchbox {
              background: none;
              border-color: #'' + config.lib.stylix.colors.base07 + ''
        ;

                color: #'' + config.lib.stylix.colors.base07 + ''
          ;

                  margin-top: 20px;
                  margin-bottom: 20px;

                  font-size: 20px;
              }

              #separator {
                  background-color: rgba(''
    + config.lib.stylix.colors.base00-rgb-r + ","
    + config.lib.stylix.colors.base00-rgb-g + ","
    + config.lib.stylix.colors.base00-rgb-b + "," + ''
      0.55);

              color: #'' + config.lib.stylix.colors.base07 + ''
        ;
                margin-left: 500px;
                margin-right: 500px;
                margin-top: 10px;
                margin-bottom: 10px
            }

            #description {
                margin-bottom: 20px
            }
      '';
  home.file.".config/nwg-launchers/nwggrid/terminal".text = "alacritty -e";
  home.file.".config/nwg-drawer/drawer.css".text = ''
    window {
        background-color: rgba('' + config.lib.stylix.colors.base00-rgb-r + ","
    + config.lib.stylix.colors.base00-rgb-g + ","
    + config.lib.stylix.colors.base00-rgb-b + "," + ''
      0.55);
              color: #'' + config.lib.stylix.colors.base07 + ''
        }

        /* search entry */
        entry {
            background-color: rgba('' + config.lib.stylix.colors.base01-rgb-r
    + "," + config.lib.stylix.colors.base01-rgb-g + ","
    + config.lib.stylix.colors.base01-rgb-b + "," + ''
      0.45);
          }

          button, image {
              background: none;
              border: none
          }

          button:hover {
              background-color: rgba('' + config.lib.stylix.colors.base02-rgb-r
    + "," + config.lib.stylix.colors.base02-rgb-g + ","
    + config.lib.stylix.colors.base02-rgb-b + "," + ''
      0.45);
          }

          /* in case you wanted to give category buttons a different look */
          #category-button {
              margin: 0 10px 0 10px
          }

          #pinned-box {
              padding-bottom: 5px;
              border-bottom: 1px dotted;
              border-color: #'' + config.lib.stylix.colors.base07 + ''
        ;
            }

            #files-box {
                padding: 5px;
                border: 1px dotted gray;
                border-radius: 15px
                border-color: #'' + config.lib.stylix.colors.base07 + ''
          ;
              }
        '';
 home.file.".local/share/pixmaps/hyprland-logo-stylix.svg".source =
    config.lib.stylix.colors {
      template = builtins.readFile ../../../pkgs/hyprland-logo-stylix.svg.mustache;
      extension = "svg";
    };

}
