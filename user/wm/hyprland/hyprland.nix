{ config, lib, pkgs, stdenv, toString, ags, browser, term, spawnEditor, font, hyprland-plugins, timezone, ... }:

# Hyprland ahead! Here ye must define settins'- in nix no less, yargh!
{
  imports = [
    ../../app/terminal/alacritty.nix
    ../../app/terminal/kitty.nix
    (import ../../app/dmenu-scripts/networkmanager-dmenu.nix {
      dmenu_command = "fuzzel -d";
      inherit config lib pkgs;
    })
    ./lib/waybar.nix
    ./lib/eww/eww.nix
    ./lib/swaylock.nix
   #ags
  ];
  gtk.cursorTheme = {
    package = pkgs.bibata-cursors;
    name = if (config.stylix.polarity == "light") then "Bibata-Modern-Classic" else "Bibata-Modern-Ice";
    size = 24;
  };

# programs.ags = {
#   enable = true;
#   configDir = ./lib/ags;
# };

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
    ];
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      exec-once = [
        "dbus-update-activation-environment DISPLAY XAUTHORITY WAYLAND_DISPLAY:"
        ("hyprctl setcursor" + config.gtk.cursorTheme.name + builtins.toString config.gtk.cursorTheme.size)
        "pypr"
        "nm-applet"
        "STEAM_FRAME_FORCE_CLOSE=1 SDL_VIDEODRIVER=x11 steam -silent"
        "blueman-applet"
        "GOMAXPROCS=1 syncthing --no-browser"
        "protonmail-bridge --noninteractive"
        "waybar"
        "emacs --daemon"
        "swayidle -w timeout 120 'swaylock -f'"
      ];

      exec = "~/.swaybg-stylix";

      general = {
        layout = "dwindle";
        resize_on_border = true;
        cursor_inactive_timeout = 30;
        border_size = 3;
        no_cursor_warps = false;
        "col.active_border" = "0xff" + config.lib.stylix.colors.base08;
        "col.inactive_border" = "0xff" + config.lib.stylix.colors.base00;

        gaps_in = 7;
        gaps_out = 7;

        allow_tearing = false;
      };

      decoration = {
        rounding = 10;
        blur = {
          size = 6;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
          noise = 0.1;
          contrast = 1.1;
          brightness = 1.8;
          xray = true;
        };
        drop_shadow = true;
        shadow_ignore_window = true;
        shadow_offset = "0 8";
        shadow_range = 50;
        shadow_render_power = 3;
        blurls = [
          #"waybar"
          "lockscreen"
          "popup"
        ];
      };

      input = {
        sensitivity = "-0.5";
        force_no_accel = true;
        kb_layout = "us";
        numlock_by_default = true;
        repeat_delay = 350;
        repeat_rate = 50;
        follow_mouse = 1;
        touchpad = {
          natural_scroll = false;
        };
      };

      xwayland.force_zero_scaling = true;

     #opengl.nvidia_anti_flicker = true;

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = false;
        animate_mouse_windowdragging = false;
      };

      animations = {
        enabled = true;
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        no_gaps_when_only = false;
      };

      master = {
        new_is_master = true;
      };

      env = [
      "XDG_SESSION_TYPE,wayland"
      "XDG_SESSION_DESKTOP,Hyprland"

      "GDK_BACKEND,wayland"
      "WLR_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0"
      "QT_QPA_PLATFORM,wayland"
      "QT_QPA_PLATFORMTHEME,qt5ct"
      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      "QT_AUTO_SCREEN_SCALE_FACTOR,1"

      "SDL_VIDEODRIVER,wayland"
      "_JAVA_AWT_WM_NONEPARENTING,1"
      "WLR_NO_HARDWARE_CURSORS,1"
     #"WLR_DRM_NO_ATOMIC,1"
      "LIBVA_DRIVER_NAME,nvidia"
      "GBM_BACKEND,nvidia-drm"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"

      "MOZ_DISABLE_RDD_SANDBOX,1"
      "MOZ_ENABLE_WAYLAND,1"
      ];
#  _              _     _           _
# | | _____ _   _| |__ (_)_ __   __| |___
# | |/ / _ | | | | '_ \| | '_ \ / _` / __|
# |   |  __| |_| | |_) | | | | | (_| \__ \
# |_|\_\___|\__, |_.__/|_|_| |_|\__,_|___/
#           |___/
#   KEYBINDS
      "$mod" = "SUPER";

      bind = [
        "$mod,          SPACE,      fullscreen, 1"
        "$modSHIFT,     SPACE,      fullscreen,"

       ("$mod,          RETURN,     exec," + term)

        "$modCTRL,      R,          exec, killall .waybar-wrapped && waybar & disown"

       ("$mod,          A,          exec," + spawnEditor)

        # Browse the seas
       ("$mod,          S,          exec," + browser)
        "$modCTRL,      S,          exec, container-open" # this one only works for qutebrowser

        "$mod,          SEMICOLON,  exec, fuzzel"
        "$mod,          X,          exec, fnottctl dismiss"
        "$modSHIFT,     X,          exec, fnottctl dismiss all"
        "$mod,          Q,          killactive"
        "$mod,          T,          togglefloating"
        "$modSHIFT,     T,          workspaceopt, allfloat"
        "$mod,          Y,          togglesplit, #dwindle"
        "$mod,          P,          pseudo, #dwindle"
        "$mod,          COMMA,      centerwindow"
        "$mod,          M,          pin"

        # Media keys to navigate the soundwaves. Get it? soundWAVES, like the theme is pirate speak and they-
        ",              xf86audiolowervolume, exec, pamixer -d 5"
        ",              xf86audioraisevolume, exec, pamixer -i 5"
        ",              xf86audioplay,        exec, playerctl play-pause"
        ",              xf86audionext,        exec, playerctl next"
        ",              xf86audioprev,        exec, playerctl prev"
        ",              code:232,             exec, brightnessctl set 15-"
        ",              code:233,             exec, brightnessctl set +15"

        "$mod,          I,          exec, networkmanager_dmenu"

        # Move focus 'tween windows
        "$mod,          H,          moveFocus, l"
        "$mod,          J,          moveFocus, d"
        "$mod,          K,          moveFocus, u"
        "$mod,          L,          moveFocus, r"
        "$mod,          LEFT,       moveFocus, l"
        "$mod,          DOWN,       moveFocus, d"
        "$mod,          UP,         moveFocus, u"
        "$mod,          RIGHT,      moveFocus, r"
        "ALT,           TAB,        cyclenext" # lest forget ye good ol' alt+tab
        "ALT,           TAB,        bringactivetotop"

        # Move windows 'round
        "$modSHIFT,     H,          moveWindow, l"
        "$modSHIFT,     J,          moveWindow, d"
        "$modSHIFT,     K,          moveWindow, u"
        "$modSHIFT,     L,          moveWindow, r"
        "$modSHIFT,     LEFT,       moveWindow, l"
        "$modSHIFT,     DOWN,       moveWindow, d"
        "$modSHIFT,     UP,         moveWindow, u"
        "$modSHIFT,     RIGHT,      moveWindow, r"

        # Move 'round the workspaces
        "$mod,          1,          workspace, 1"
        "$mod,          2,          workspace, 2"
        "$mod,          3,          workspace, 3"
        "$mod,          4,          workspace, 4"
        "$mod,          5,          workspace, 5"
        "$mod,          6,          workspace, 6"
        "$mod,          7,          workspace, 7"
        "$mod,          8,          workspace, 8"
        "$mod,          9,          workspace, 9"
        "$mod,        BRACKETRIGHT, workspace, e+1"
        "$mod,        BRACKETLEFT,  workspace, e-1"
        "$mod,          mouse_down, workspace, e+1"
        "$mod,          mouse_up,   workspace, e-1"

        # Move windows 'tween workspaces
        "$modSHIFT,     1,          moveToWorkspace, 1"
        "$modSHIFT,     2,          moveToWorkspace, 2"
        "$modSHIFT,     3,          moveToWorkspace, 3"
        "$modSHIFT,     4,          moveToWorkspace, 4"
        "$modSHIFT,     5,          moveToWorkspace, 5"
        "$modSHIFT,     6,          moveToWorkspace, 6"
        "$modSHIFT,     7,          moveToWorkspace, 7"
        "$modSHIFT,     8,          moveToWorkspace, 8"
        "$modSHIFT,     9,          moveToWorkspace, 9"

        # Move windows 'tween workspaces, but silently ~oOoOoOoOoOhh, lest ol' Davy Jones'll haunt ye
        "$modCTRL,      1,          moveToWorkspaceSilent, 1"
        "$modCTRL,      2,          moveToWorkspaceSilent, 2"
        "$modCTRL,      3,          moveToWorkspaceSilent, 3"
        "$modCTRL,      4,          moveToWorkspaceSilent, 4"
        "$modCTRL,      5,          moveToWorkspaceSilent, 5"
        "$modCTRL,      6,          moveToWorkspaceSilent, 6"
        "$modCTRL,      7,          moveToWorkspaceSilent, 7"
        "$modCTRL,      8,          moveToWorkspaceSilent, 8"
        "$modCTRL,      9,          moveToWorkspaceSilent, 9"

        # Here be the scratchpad bindings, arr
        "$mod,          Z,          exec, pypr toggle term && hyprctl dispatch bringactivetotop"
        "$mod,          F,          exec, pypr toggle ranger && hyprctl dispatch bringactivetotop"
        "$mod,          N,          exec, pypr toggle musikcube && hyprctl dispatch bringactivetotop"
        "$mod,          B,          exec, pypr toggle btm && hyprctl dispatch bringactivetotop"
        "$mod,          code:172,   exec, pypr toggle pavucontrol && hyprctl dispatch bringactivetotop"
      ];

      # Stop repeating yeself lad, we've heard ya blabbering all day
      binde = [
        "$modCTRL,      H,          resizeactive, -20 0"
        "$modCTRL,      J,          resizeactive, 0 20"
        "$modCTRL,      K,          resizeactive, 0 -20"
        "$modCTRL,      L,          resizeactive, 20 0"
        "$modCTRL,      LEFT,       resizeactive, -20 0"
        "$modCTRL,      DOWN,       resizeactive, 0 20"
        "$modCTRL,      UP,         resizeactive, 0 -20"
        "$modCTRL,      RIGHT,      resizeactive, 20 0"
      ];

      # Bind those pesky mouses- mice? mouse?
      bindm = [
        "$mod,          mouse:272,  movewindow"
        "$mod,          mouse:273,  resizewindow"
      ];
      "$scratchpadsize" = "size 80% 85%";

      "$scratchpad"     = "class:^(scratchpad)$";
      "$pavucontrol"    = "class:^(pavucontrol)$";
#           _           _                          _
# __      _(_)_ __   __| | _____      ___ __ _   _| | ___ ___
# \ \ /\ / | | '_ \ / _` |/ _ \ \ /\ / | '__| | | | |/ _ / __|
#  \ V  V /| | | | | (_| | (_) \ V  V /| |  | |_| | |  __\__ \
#   \_/\_/ |_|_| |_|\__,_|\___/ \_/\_/ |_|   \__,_|_|\___|___/
#   WINDOWRULES
      # Would some 'o ye wipe the darn windows? I'm stretching this pirate thing alot
      windowrulev2 = [
        "float,$scratchpad"
        "$scratchpadsize,$scratchpad"
        "workspace special silent,$scratchpad"
        "center,$scratchpad"

        "float,$pavucontrol"
        "size 86% 40%,$pavucontrol"
        "move 50% 6%,$pavucontrol"
        "workspace special silent,$pavucontrol"
        "opacity 0.80,$pavucontrol"

        "opacity 0.80,title:ORUI"
        "opacity 0.80,title:Heimdall"
        "opacity 0.90,title:LibreWolf"
        "opacity 1.00,title:^(Youtube)$"
        "opacity 0.70,title:^(New Tab - LibreWolf)$"
        "opacity 0.80,title:^(New Tab - Brave)$"
        "opacity 0.65,title:^(My Local Dashboard Awesome Homepage - qutebrowser)$"
        "opacity 0.65,title:\[.*\] - My Local Dashboard Awesome Homepage"
        "opacity 0.90,class:^(org.keepassxc.KeePassXC)$"
        "noblur,class:^(waybar)$"
        "opacity 0.70,class:^(waybar)$"
        "immediate, class:^(Team Fortress 2)$"
        "immediate, class:^(Cult of The Lamb)"
        "immediate, class:^(Deep Rock Galactic)"
        "immediate, class:^(Hyper Demon)$"
       #"immediate, class:^(Doom)$"
      ];

    };
  };
  home.packages = with pkgs; [
    alacritty
    kitty
    mc
    feh
    killall
    polkit_gnome
    libva-utils
    gsettings-desktop-schemas
    wlr-randr
    wtype
    wl-clipboard
    hyprland-protocols
    hyprpicker
    swayidle
    swaybg
    fnott
    #hyprpaper
    #wofi
    fuzzel
    keepmenu
    pinentry-gnome
    wev
    grim
    slurp
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    wlsunset
    pavucontrol
    pamixer
    playerctl
    (pkgs.writeScriptBin "sct" ''
      #!/bin/sh
      killall wlsunset &> /dev/null;
      if [ $# -eq 1 ]; then
        temphigh=$(( $1 + 1 ))
        templow=$1
        wlsunset -t $templow -T $temphigh &> /dev/null &
      else
        killall wlsunset &> /dev/null;
      fi
    '')
    (pkgs.writeScriptBin "hyprworkspace" ''
      #!/bin/sh
      # from https://github.com/taylor85345/hyprland-dotfiles/blob/master/hypr/scripts/workspace
      monitors=/tmp/hypr/monitors_temp
      hyprctl monitors > $monitors

      if [[ -z $1 ]]; then
        workspace=$(grep -B 5 "focused: no" "$monitors" | awk 'NR==1 {print $3}')
      else
        workspace=$1
      fi

      activemonitor=$(grep -B 11 "focused: yes" "$monitors" | awk 'NR==1 {print $2}')
      passivemonitor=$(grep  -B 6 "($workspace)" "$monitors" | awk 'NR==1 {print $2}')
      #activews=$(grep -A 2 "$activemonitor" "$monitors" | awk 'NR==3 {print $1}' RS='(' FS=')')
      passivews=$(grep -A 6 "Monitor $passivemonitor" "$monitors" | awk 'NR==4 {print $1}' RS='(' FS=')')

      if [[ $workspace -eq $passivews ]] && [[ $activemonitor != "$passivemonitor" ]]; then
       hyprctl dispatch workspace "$workspace" && hyprctl dispatch swapactiveworkspaces "$activemonitor" "$passivemonitor" && hyprctl dispatch workspace "$workspace"
        echo $activemonitor $passivemonitor
      else
        hyprctl dispatch moveworkspacetomonitor "$workspace $activemonitor" && hyprctl dispatch workspace "$workspace"
      fi

      exit 0

    '')
    (pkgs.python3Packages.buildPythonPackage rec {
      pname = "pyprland";
      version = "1.4.1";
      src = pkgs.fetchPypi {
        inherit pname version;
        sha256 = "sha256-JRxUn4uibkl9tyOe68YuHuJKwtJS//Pmi16el5gL9n8=";
      };
      format = "pyproject";
      propagatedBuildInputs = with pkgs; [
        python3Packages.setuptools
        python3Packages.poetry-core
        poetry
      ];
      doCheck = false;
    })
  ];

  home.file.".config/hypr/pyprland.json".text = ''
    {
      "pyprland": {
        "plugins": ["scratchpads", "magnify"]
      },
      "scratchpads": {
        "term": {
          "command": "alacritty --class scratchpad",
          "animation": "fromBottom",
          "margin": 50
        },
        "ranger": {
          "command": "kitty --class scratchpad -e ranger",
          "animation": "fromBottom",
          "margin": 50
        },
        "musikcube": {
          "command": "alacritty --class scratchpad -e musikcube",
          "animation": "fromBottom",
          "margin": 50
        },
        "btm": {
          "command": "alacritty --class scratchpad -e btm",
          "animation": "fromBottom",
          "margin": 50
        },
        "pavucontrol": {
          "command": "pavucontrol",
          "margin": 50,
          "unfocus": "hide",
          "animation": "fromTop"
        }
      }
    }
  '';


  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = font + ":size=13";
        terminal = "${pkgs.alacritty}/bin/alacritty";
      };
    colors = {
      background = config.lib.stylix.colors.base00 + "e6";
      text = config.lib.stylix.colors.base07 + "ff";
      match = config.lib.stylix.colors.base05 + "ff";
      selection = config.lib.stylix.colors.base08 + "ff";
      selection-text = config.lib.stylix.colors.base00 + "ff";
      selection-match = config.lib.stylix.colors.base05 + "ff";
      border = config.lib.stylix.colors.base08 + "ff";
    };
   };
  };

  services.fnott = {
    enable = true;
    settings = {
      main = {
        anchor = "bottom-right";
        stacking-order = "top-down";
        min-width = 400;
        title-font = font + ":size=14";
        summary-font = font + ":size=12";
        body-font = font + ":size=11";
        border-size = 0;
      };
      low = {
        background = config.lib.stylix.colors.base00 + "e6";
        title-color = config.lib.stylix.colors.base03 + "ff";
        summary-color = config.lib.stylix.colors.base03 + "ff";
        body-color = config.lib.stylix.colors.base03 + "ff";
        idle-timeout = 150;
        max-timeout = 30;
        default-timeout = 8;
      };
      normal = {
        background = config.lib.stylix.colors.base00 + "e6";
        title-color = config.lib.stylix.colors.base07 + "ff";
        summary-color = config.lib.stylix.colors.base07 + "ff";
        body-color = config.lib.stylix.colors.base07 + "ff";
        idle-timeout = 150;
        max-timeout = 30;
        default-timeout = 8;
      };
      critical = {
        background = config.lib.stylix.colors.base00 + "e6";
        title-color = config.lib.stylix.colors.base08 + "ff";
        summary-color = config.lib.stylix.colors.base08 + "ff";
        body-color = config.lib.stylix.colors.base08 + "ff";
        idle-timeout = 0;
        max-timeout = 0;
        default-timeout = 0;
      };
    };
  };
}
