{ config, lib, pkgs, stdenv, toString, browser, term, spawnEditor, userSettings, hyprland-plugins, systemSettings, ... }:

{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      postPatch = ''
        # use hyprctl to switch workspaces
        sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprworkspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
        sed -i 's/gIPC->getSocket1Reply("dispatch workspace " + std::to_string(id()));/const std::string command = "hyprworkspace " + std::to_string(id());\n\tsystem(command.c_str());/g' src/modules/hyprland/workspaces.cpp
      '';
    });
    settings = [{
        layer = "top";
        position = "top";

        modules-left = [ "hyprland/window" ];
        modules-center = [ "network" "pulseaudio" "cpu" "hyprland/workspaces" "memory" "disk" ];
        modules-right = [ "idle_inhibitor" "tray" "clock" ];

        "hyprland/window" = {
          format = "  {}";
          max-length = 60;
          seperate-outputs = false;
        };
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
          # "1" = "󱚌";
          # "2" = "󰖟";
          # "3" = "";
          # "4" = "󰎄";
          # "5" = "󰋩";
          # "6" = "";
          # "7" = "󰄖";
          # "8" = "󰑴";
          # "9" = "󱎓";
          # "scratch_term" = "_";
          # "scratch_ranger" = "_󰴉";
          # "scratch_musikcube" = "_";
          # "scratch_btm" = "_";
          # "scratch_geary" = "_";
          # "scratch_pavucontrol" = "_󰍰";
          };
          "on-click" = "activate";
          "on-scroll-up" = "hyprctl dispatch workspace e+1";
          "on-scroll-down" = "hyprctl dispatch workspace e-1";
          #"all-outputs" = true;
          #"active-only" = true;
          "ignore-workspaces" = ["scratch" "-"];
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶";
            deactivated = "󰾪";
          };
        };
        "tray" = {
          "spacing" = 12;
        };
        "clock" = {
          interval = 1;
          format = "{:%a %Y-%m-%d %I:%M:%S %p}";
          timezone = systemSettings.timezone;
          tooltip = false;
        };
        "cpu" = {
          interval = 5;
          format = " {usage:2}%";
          tooltip = true;
        };
        "memory" = {
          interval = 5;
          format = " {}%";
          tooltip = false;
        };
        "disk" = {
          format = "  {free}";
          tooltip = true;
        };
        "network" = {
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          format-ethernet = ": {bandwidthDownOctets} : {bandwidthUpOctets}";
          format-wifi = "{icon} {signalStrength}%";
          format-disconnected = "󰤮";
          tooltip = false;
        };
        "battery" = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󱘖 {capacity}%";
          #format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          tooltip = false;
        };
        "pulseaudio" = {
          scroll-step = 1;
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pypr toggle pavucontrol && hyprctl dispatch bringactivetotop";
        };
    }];
    style = ''
      * {
          font-family: FontAwesome, ''+userSettings.font+'';
          font-weight: bold;
          font-size: 16px;
      }

      window#waybar {
          background-color: rgba(26,27,38,0);
          border-bottom: 0px solid rgba(26,27,38,0);
          border-radius: 0px;
          color: #${config.lib.stylix.colors.base0F};
      }
      #workspaces {
          background: linear-gradient(180deg, #${config.lib.stylix.colors.base00}, #${config.lib.stylix.colors.base01});
          margin: 5px;
          padding: 0px 1px;
          border-radius: 15px;
          border: 0px;
          font-style: normal;
          color: #${config.lib.stylix.colors.base00};
      }
      #workspaces button {
          padding: 0px 5px;
          margin: 4px 3px;
          border-radius: 15px;
          border: 0px;
          background-color: #${config.lib.stylix.colors.base00};
          color: #${config.lib.stylix.colors.base00};
          opacity: 1.0;
          transition: all 0.3s ease-in-out;
      }
      #workspaces button.active {
          color: #${config.lib.stylix.colors.base00};
          background: #${config.lib.stylix.colors.base04};
          border-radius: 15px;
          min-width: 40px;
          opacity: 1.0;
      }
      #workspaces button:hover {
          color: #${config.lib.stylix.colors.base00};
          background: #${config.lib.stylix.colors.base04};
          border-radius: 15px;
          opacity: 1.0;
      }
     tooltip {
      background: #${config.lib.stylix.colors.base00};
      border: 1px solid #${config.lib.stylix.colors.base04};
      border-radius: 10px;
     }
     tooltip label {
      color: #${config.lib.stylix.colors.base07};
     }
      #window {
          color: #${config.lib.stylix.colors.base05};
          background: #${config.lib.stylix.colors.base00};
          border-radius: 50px 15px 50px 15px;
          margin: 5px 5px 5px 5px;
          padding: 2px 20px;
      }
      #memory {
        color: #${config.lib.stylix.colors.base0F};
        background: #${config.lib.stylix.colors.base00};
        border-radius: 15px 50px 15px 50px;
        margin: 5px;
        padding: 2px 20px;
      }
      #clock {
        color: #${config.lib.stylix.colors.base0B};
        background: #${config.lib.stylix.colors.base00};
        border-radius: 15px 50px 15px 50px;
        margin: 5px;
        padding: 2px 20px;
      }
      #cpu {
        color: #${config.lib.stylix.colors.base07};
        background: #${config.lib.stylix.colors.base00};
        border-radius: 50px 15px 50px 15px;
        margin: 5px;
        padding: 2px 20px;
      }
      #disk {
        color: #${config.lib.stylix.colors.base03};
        background: #${config.lib.stylix.colors.base00};
        border-radius: 15px;
        margin: 5px;
        padding: 2px 20px;
      }
      #battery {
        color: #${config.lib.stylix.colors.base08};
        background: #${config.lib.stylix.colors.base00};
        border-radius: 15px;
        margin: 5px;
        padding: 2px 20px;
      }
      #network {
        color: #${config.lib.stylix.colors.base09};
        background: #${config.lib.stylix.colors.base00};
        border-radius: 50px 15px 50px 15px;
        margin: 5px;
        padding: 2px 20px;
      }
      #tray {
        color: #${config.lib.stylix.colors.base05};
        background: #${config.lib.stylix.colors.base00};
        border-radius: 15px 50px 15px 50px;
        margin: 5px 0px 5px 5px;
        padding: 2px 20px;
      }
      #pulseaudio {
        color: #${config.lib.stylix.colors.base0D};
        background: #${config.lib.stylix.colors.base00};
        border-radius: 50px 15px 50px 15px;
        margin: 5px;
        padding: 2px 20px;
      }
      #idle_inhibitor {
          color: #${config.lib.stylix.colors.base0C};
          background: #${config.lib.stylix.colors.base00};
          border-radius: 15px 50px 15px 50px;
          margin: 5px;
          padding: 2px 20px;
      }
      #idle_inhibitor.activated {
          color: #${config.lib.stylix.colors.base0F};
          background: #${config.lib.stylix.colors.base00};
          border-radius: 15px 50px 15px 50px;
          margin: 5px;
          padding: 2px 20px;
      }
      '';
  };
}
