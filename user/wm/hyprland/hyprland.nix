{ inputs, config, lib, pkgs, userSettings, systemSettings
, pkgs-nwg-dock-hyprland, ... }:
let
  pkgs-hyprland =
    inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [
    ../../app/terminal/alacritty.nix
    ../../app/terminal/kitty.nix
    (import ../../app/dmenu-scripts/networkmanager-dmenu.nix {
      dmenu_command = "fuzzel -d";
      inherit config lib pkgs;
    })
   ./lib/waybar.nix
   ./lib/fnott.nix
   ./lib/fuzzel.nix
   ./lib/nwg.nix
  ];

  gtk.cursorTheme = {
    package = pkgs.bibata-cursors;
    name = if (config.stylix.polarity == "light") then
      "Bibata-Modern-Classic"
    else
      "Bibata-Modern-Ice";
    size = 24;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprtrails
      inputs.hycov.packages.${pkgs.system}.hycov
    ];
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      exec-once = [
        "dbus-update-activation-environment DISPLAY XAUTHORITY WAYLAND_DISPLAY:"
        ("hyprctl setcursor" + config.gtk.cursorTheme.name
          + builtins.toString config.gtk.cursorTheme.size)
        "pypr"
        "nm-applet"
        "STEAM_FRAME_FORCE_CLOSE=1 SDL_VIDEODRIVER=x11 steam -silent"
        "blueman-applet"
        "GOMAXPROCS=1 syncthing --no-browser"
        "protonmail-bridge --noninteractive"
        "dropbox start"
        "waybar"
        "emacs --daemon"
        "swayidle -w timeout 120 'swaylock -f'"
        "ydotoold"

        "hyprprofile Default"
        "hypr-element-start"
        "hypridle"
        "hyprpaper"
        "sleep 5 && libinput-gestures"
      ];

      exec = [ "~/.swaybg-stylix" ];

      monitor = [ "HDMI-A-2, 2560x1440@144, 0x0, 1" ];

      general = {
        layout = "dwindle";
        resize_on_border = true;
        border_size = 3;
        "col.active_border" = "0xaa" + config.lib.stylix.colors.base05;

        "col.inactive_border" = "0xaa" + config.lib.stylix.colors.base03;

        gaps_in = 7;
        gaps_out = 7;

        allow_tearing = true;
      };

      cursor = {
        no_warps = true;
        inactive_timeout = 30;
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
          brightness = if (config.stylix.polarity == "dark") then 0.8 else 1.15;
          xray = true;
        };
        drop_shadow = true;
        shadow_ignore_window = true;
        shadow_offset = "0 8";
        shadow_range = 50;
        shadow_render_power = 3;
        blurls = [ "lockscreen" "popup" ];
      };

      input = {
        sensitivity = "-0.5";
        force_no_accel = true;
        kb_layout = "us";
        numlock_by_default = false;
        repeat_delay = 350;
        repeat_rate = 50;
        follow_mouse = 1;
        mouse_refocus = false;
        touchpad = {
          natural_scroll = false;
          clickfinger_behavior = true;
        };
      };

      xwayland.force_zero_scaling = true;

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
          "linear, 0, 0, 1.0, 1.0"
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

      master = { new_is_master = true; };

      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"

        "GDK_BACKEND,wayland,x11,*"
        "WLR_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"

        "SDL_VIDEODRIVER,wayland"
        "_JAVA_AWT_WM_NONEPARENTING,1"
        "WLR_NO_HARDWARE_CURSORS,1"

        "WLR_DRM_NO_ATOMIC,0"

        "MOZ_DISABLE_RDD_SANDBOX,1"
        "MOZ_ENABLE_WAYLAND,1"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
      ];
      #  _              _     _           _
      # | | _____ _   _| |__ (_)_ __   __| |___
      # | |/ / _ | | | | '_ \| | '_ \ / _` / __|
      # |   |  __| |_| | |_) | | | | | (_| \__ \
      # |_|\_\___|\__, |_.__/|_|_| |_|\__,_|___/
      #           |___/
      #   KEYBINDS
      "$mod" = "SUPER";

      group = {
        groupbar = {
          enabled = true;
          scrolling = true;
          render_titles = false;
          height = 1;
          gradients = true;
          "col.active" = "rgb(${config.lib.stylix.colors.base0E})" + " " + "rgb(${config.lib.stylix.colors.base0B})" + " " + "270deg";
          "col.inactive" = "0xaa" + config.lib.stylix.colors.base03;
        };
        "col.border_active" = "0xaa" + config.lib.stylix.colors.base05;
        "col.border_inactive" = "0xaa" + config.lib.stylix.colors.base03;
      };
      bind = [
        "$mod,          SPACE,      fullscreen, 1"
        "$modSHIFT,     SPACE,      fullscreen,0"

        ("$mod,          RETURN,     exec," + userSettings.term)

        "$modCTRL,      R,          exec, killall .waybar-wrapped && waybar & disown"

        ("$mod,          A,          exec," + userSettings.spawnEditor)

        # Browse the seas
        ("$mod,          S,          exec," + userSettings.browser)
        "$modCTRL,      S,          exec, container-open" # this one only works for qutebrowser

        "$mod,          SUPER_L,    exec, nwggrid-wrapper"
        "$mod,          W,          exec, nwg-dock-wrapper"
        "$mod,          SUPER_R,    hyprexpo:expo, toggle"
        "$mod,          APOSTROPHE, togglegroup"
        "$mod,          COMMA,      changegroupactive, b"
        "$mod,          PERIOD,     changegroupactive, f"
        "$mod,          E,          exec, fuzzel"
        "$mod,          X,          exec, fnottctl dismiss"
        "$modSHIFT,     X,          exec, fnottctl dismiss all"
        "$mod,          Q,          killactive"
        "$mod,          T,          togglefloating"
        "$modSHIFT,     T,          workspaceopt, allfloat"
        "$mod,          Y,          togglesplit, #dwindle"
        "$mod,          P,          pseudo, #dwindle"
        "$mod,          C,          centerwindow"
        "$mod,          M,          pin"
        "$mod,          R,          exec, phoenix refresh"

        # Workspace-window overview ( hycov )
        "$mod,          TAB,        hycov:toggleoverview"
        "$mod,          LEFT,       hycov:movefocus,leftcross"
        "$mod,          RIGHT,      hycov:movefocus,rightcross"
        "$mod,          UP,         hycov:movefocus,upcross"
        "$mod,          DOWN,       hycov:movefocus,downcross"

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
        "$mod,          1,          focusworkspaceoncurrentmonitor, 1"
        "$mod,          2,          focusworkspaceoncurrentmonitor, 2"
        "$mod,          3,          focusworkspaceoncurrentmonitor, 3"
        "$mod,          4,          focusworkspaceoncurrentmonitor, 4"
        "$mod,          5,          focusworkspaceoncurrentmonitor, 5"
        "$mod,          6,          focusworkspaceoncurrentmonitor, 6"
        "$mod,          7,          focusworkspaceoncurrentmonitor, 7"
        "$mod,          8,          focusworkspaceoncurrentmonitor, 8"
        "$mod,          9,          focusworkspaceoncurrentmonitor, 9"
        "$mod,        BRACKETRIGHT, exec, hyprnome"
        "$mod,        BRACKETLEFT,  exec, hyprnome --previous"
        "$mod,          mouse_down, exec, hyprnome"
        "$mod,          mouse_up,   exec, hyprnome --previous"

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
        "$mod,          F,          exec, pypr toggle yazi && hyprctl dispatch bringactivetotop"
        "$mod,          N,          exec, pypr toggle numbat && hyprctl dispatch bringactivetotop"
        "$mod,          M,          exec, pypr toggle musikcube && hyprctl dispatch bringactivetotop"
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

      "$scratchpad" = "class:^(scratchpad)$";
      "$pavucontrol" = "class:^(pavucontrol)$";
      "$savetodisk" = "class:^(Save to Disk)$";
      "$miniframe" = "title:\*Minibuf.*";
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

      # Pavucontrol
        "float,$pavucontrol"
        "size 86% 40%,$pavucontrol"
        "move 50% 6%,$pavucontrol"
        "workspace special silent,$pavucontrol"
        "opacity 0.80,$pavucontrol"

      # Savetodisk
        "float,$savetodisk"
        "size 70% 75%,$savetodisk"
        "center,$savetodisk"

      # Miniframe
        "float,$miniframe"
        "size 64% 50%,$miniframe"
        "move 18% 25%,$miniframe"
        "animation popin 1 20,$miniframe"


        "opacity 0.80,title:ORUI"
        "opacity 0.80,title:Heimdall"
        "opacity 0.90,title:LibreWolf"
        "opacity 1.00,title:^(Youtube)$"
        "opacity 0.70,title:^(New Tab - LibreWolf)$"
        "opacity 0.80,title:^(New Tab - Brave)$"
        "opacity 0.65,title:^(My Local Dashboard Awesome Homepage - qutebrowser)$"
        "opacity 0.65,title:[.*] - My Local Dashboard Awesome Homepage"
        "opacity 0.90,class:^(org.keepassxc.KeePassXC)$"
        "noblur,class:^(waybar)$"
        "opacity 0.70,class:^(waybar)$"
      ];
      plugin = {
        hyprtrails = {
          color = "rgba(${config.lib.stylix.colors.base08}55)";
        };
        hycov = {
          overview_gappo = 60;# gaps width from screen edge
          overview_gappi = 24; # gaps width from clients
          enable_hotarea = 0; # enable mouse cursor hotarea, when cursor enter hotarea, it will toggle overview
          enable_click_action = 1; # enable mouse left button jump and right button kill in overview mode
          hotarea_monitor = "all"; # monitor name which hotarea is in, default is all
          hotarea_pos = 1; # position of hotarea (1: bottom left, 2: bottom right, 3: top left, 4: top right)
          hotarea_size = 10; # hotarea size, 10x10
          swipe_fingers = 3; # finger number of gesture,move any directory
          move_focus_distance = 100; # distance for movefocus,only can use 3 finger to move
          enable_gesture = 0; # enable gesture
          auto_exit = 1; # enable auto exit when no client in overview
          auto_fullscreen = 0; # auto make active window maximize after exit overview
          only_active_workspace = 0; # only overview the active workspace
          only_active_monitor = 0; # only overview the active monitor
          enable_alt_release_exit = 0; # alt swith mode arg,see readme for detail
          alt_replace_key = "Super_L"; # alt swith mode arg,see readme for detail
          alt_toggle_auto_next = 0; # auto focus next window when toggle overview in alt swith mode
          click_in_cursor = 1; # when click to jump,the target windwo is find by cursor, not the current foucus window.
          hight_of_titlebar = 0; # height deviation of title bar height
          show_special = 0; # show windwos in special workspace in overview.
        };
        hyprexpo = {
          columns = 5;
          gap_size = 5;
          bg_col = "rgb(${config.lib.stylix.colors.base00})";
          workspace_method = "first 1"; # [center/first] [workspace] e.g. first 1 or center m+1

          enable_gesture = true; # laptop touchpad
          gesture_fingers = 3;  # 3 or 4
          gesture_distance = 300; # how far is the "max"
          gesture_positive = true; # positive = swipe down. Negative = swipe up.
        };
      };
    };
  };
  home.packages = (with pkgs; [
    alacritty
    kitty
    feh
    killall
    polkit_gnome
    nwg-launchers
    papirus-icon-theme
    (pkgs.writeScriptBin "nwggrid-wrapper" ''
      #!/bin/sh
      if pgrep -x "nwggrid-server" > /dev/null
      then
        nwggrid -client
      else
        GDK_PIXBUF_MODULE_FILE=${pkgs.librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache nwggrid-server -layer-shell-exclusive-zone -1 -g adw-gtk3 -o 0.55 -b ${config.lib.stylix.colors.base00}
      fi
    '')
    libva-utils
    libinput-gestures
    gsettings-desktop-schemas
    (pkgs.makeDesktopItem {
      name = "nwggrid";
      desktopName = "Application Launcher";
      exec = "nwggrid-wrapper";
      terminal = false;
      type = "Application";
      noDisplay = true;
      icon = "/home/" + userSettings.username
        + "/.local/share/pixmaps/hyprland-logo-stylix.svg";
    })
    (pyprland.overrideAttrs (oldAttrs: {
      src = fetchFromGitHub {
        owner = "hyprland-community";
        repo = "pyprland";
        rev = "refs/tags/2.2.17";
        hash = "sha256-S1bIIazrBWyjF8tOcIk0AwwWq9gbpTKNsjr9iYA5lKk=";
      };
    }))
    (hyprnome.override (oldAttrs: {
      rustPlatform = oldAttrs.rustPlatform // {
        buildRustPackage = args:
          oldAttrs.rustPlatform.buildRustPackage (args // {
            pname = "hyprnome";
            version = "unstable-2024-05-06";
            src = fetchFromGitHub {
              owner = "donovanglover";
              repo = "hyprnome";
              rev = "f185e6dbd7cfcb3ecc11471fab7d2be374bd5b28";
              hash = "sha256-tmko/bnGdYOMTIGljJ6T8d76NPLkHAfae6P6G2Aa2Qo=";
            };
            cargoDeps = oldAttrs.cargoDeps.overrideAttrs (oldAttrs: rec {
              name = "${pname}-vendor.tar.gz";
              inherit src;
              outputHash =
                "sha256-cQwAGNKTfJTnXDI3IMJQ2583NEIZE7GScW7TsgnKrKs=";
            });
            cargoHash = "sha256-cQwAGNKTfJTnXDI3IMJQ2583NEIZE7GScW7TsgnKrKs=";
          });
      };
    }))
    gnome.zenity
    wlr-randr
    wtype
    ydotool
    wl-clipboard
    hyprland-protocols
    hyprpicker
    hypridle
    hyprpaper
    fnott
    fuzzel
    keepmenu
    pinentry-gnome3
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
    tesseract4
    (pkgs.writeScriptBin "screenshot-ocr" ''
      #!/bin/sh
      imgname="/tmp/screenshot-ocr-$(date +%Y%m%d%H%M%S).png"
      txtname="/tmp/screenshot-ocr-$(date +%Y%m%d%H%M%S)"
      txtfname=$txtname.txt
      grim -g "$(slurp)" $imgname;
      tesseract $imgname $txtname;
      wl-copy -n < $txtfname
    '')
    (pkgs.writeScriptBin "nwg-dock-wrapper" ''
      #!/bin/sh
      if pgrep -x ".nwg-dock-hyprl" > /dev/null
      then
        nwg-dock-hyprland
      else
        nwg-dock-hyprland -f -x -i 64 -nolauncher -a start -ml 8 -mr 8 -mb 8
      fi
    '')
    (pkgs.writeScriptBin "hypr-element-start" ''
      #!/usr/bin/env sh
      sleep 6 && element-desktop --hidden
    '')
    (pkgs.writeScriptBin "hypr-element" ''
      #!/bin/sh
      if hyprctl clients | grep "class: Element" > /dev/null
      then
        hyprctl dispatch closewindow Element
      else
        element-desktop
      fi
    '')
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
    (pkgs.writeScriptBin "obs-notification-mute-daemon" ''
      #!/bin/sh
      while true; do
        if pgrep -x .obs-wrapped > /dev/null;
          then
            pkill -STOP fnott;
          else
            pkill -CONT fnott;
        fi
        sleep 10;
      done
    '')
    (pkgs.writeScriptBin "suspend-unless-render" ''
      #!/bin/sh
      if pgrep -x nixos-rebuild > /dev/null || pgrep -x home-manager > /dev/null || pgrep -x kdenlive > /dev/null || pgrep -x FL64.exe > /dev/null || pgrep -x blender > /dev/null || pgrep -x flatpak > /dev/null;
      then echo "Shouldn't suspend"; sleep 10; else echo "Should suspend"; systemctl suspend; fi
    '')
    (pkgs.makeDesktopItem {
      name = "emacsclientnewframe";
      desktopName = "Emacs Client New Frame";
      exec = "emacsclient -c -a emacs";
      terminal = false;
      icon = "emacs";
      type = "Application";
    })
  ]) ++ (with pkgs-hyprland; [ hyprlock ]) ++ (with pkgs-nwg-dock-hyprland;
    [
      (nwg-dock-hyprland.overrideAttrs
        (oldAttrs: { patches = ./patches/noactiveclients.patch; }))
    ]);
   home.file.".config/hypr/hypridle.conf".text = ''
    general {
      lock_cmd = pgrep hyprlock || hyprlock
      before_sleep_cmd = loginctl lock-session
      ignore_dbus_inhibit = false
    }

    listener {
      timeout = 300 # in seconds
      on-timeout = loginctl lock-session
    }
    listener {
      timeout = 600 # in seconds
      on-timeout = systemctl suspend
    }
  '';
  home.file.".config/hypr/hyprlock.conf".text = ''
    background {
      monitor =
      path = screenshot

      # all these options are taken from hyprland, see https://wiki.hyprland.org/Configuring/Variables/#blur for explanations
      blur_passes = 4
      blur_size = 5
      noise = 0.0117
      contrast = 0.8916
      brightness = 0.8172
      vibrancy = 0.1696
      vibrancy_darkness = 0.0
    }

    # doesn't work yet
    image {
      monitor =
      path = /home/emmet/.dotfiles/user/wm/hyprland/nix-dark.png
      size = 150 # lesser side if not 1:1 ratio
      rounding = -1 # negative values mean circle
      border_size = 0
      rotate = 0 # degrees, counter-clockwise

      position = 0, 200
      halign = center
      valign = center
    }

    input-field {
      monitor =
      size = 200, 50
      outline_thickness = 3
      dots_size = 0.33 # Scale of input-field height, 0.2 - 0.8
      dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
      dots_center = false
      dots_rounding = -1 # -1 default circle, -2 follow input-field rounding
      outer_color = rgb('' + config.lib.stylix.colors.base07-rgb-r + ","
    + config.lib.stylix.colors.base07-rgb-g + ", "
    + config.lib.stylix.colors.base07-rgb-b + ''
      )
            inner_color = rgb('' + config.lib.stylix.colors.base00-rgb-r + ","
    + config.lib.stylix.colors.base00-rgb-g + ", "
    + config.lib.stylix.colors.base00-rgb-b + ''
      )
            font_color = rgb('' + config.lib.stylix.colors.base07-rgb-r + ","
    + config.lib.stylix.colors.base07-rgb-g + ", "
    + config.lib.stylix.colors.base07-rgb-b + ''
      )
            fade_on_empty = true
            fade_timeout = 1000 # Milliseconds before fade_on_empty is triggered.
            placeholder_text = <i>Input Password...</i> # Text rendered in the input box when it's empty.
            hide_input = false
            rounding = -1 # -1 means complete rounding (circle/oval)
            check_color = rgb('' + config.lib.stylix.colors.base0A-rgb-r + ","
    + config.lib.stylix.colors.base0A-rgb-g + ", "
    + config.lib.stylix.colors.base0A-rgb-b + ''
      )
            fail_color = rgb('' + config.lib.stylix.colors.base08-rgb-r + ","
    + config.lib.stylix.colors.base08-rgb-g + ", "
    + config.lib.stylix.colors.base08-rgb-b + ''
      )
            fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i> # can be set to empty
            fail_transition = 300 # transition time in ms between normal outer_color and fail_color
            capslock_color = -1
            numlock_color = -1
            bothlock_color = -1 # when both locks are active. -1 means don't change outer color (same for above)
            invert_numlock = false # change color if numlock is off
            swap_font_color = false # see below

            position = 0, -20
            halign = center
            valign = center
          }

          label {
            monitor =
            text = Hello, ${userSettings.name}
            color = rgb('' + config.lib.stylix.colors.base07-rgb-r + ","
    + config.lib.stylix.colors.base07-rgb-g + ", "
    + config.lib.stylix.colors.base07-rgb-b + ''
      )
            font_size = 25
            font_family = '' + userSettings.font + ''

          rotate = 0 # degrees, counter-clockwise

          position = 0, 160
          halign = center
          valign = center
        }

        label {
          monitor =
          text = $TIME
          color = rgb('' + config.lib.stylix.colors.base07-rgb-r + ","
    + config.lib.stylix.colors.base07-rgb-g + ", "
    + config.lib.stylix.colors.base07-rgb-b + ''
      )
            font_size = 20
            font_family = Intel One Mono
            rotate = 0 # degrees, counter-clockwise

            position = 0, 80
            halign = center
            valign = center
          }
    '';
  home.file.".config/hypr/pyprland.toml".text = ''
    [pyprland]
    plugins = ["scratchpads", "magnify"]

    [scratchpads.term]
    command = "kitty --class scratchpad"
    margin = 50
    animation = "fromBottom"

    [scratchpads.yazi]
    command = "kitty --class scratchpad -e yazi"
    margin = 100
    animation = "fromTop"

    [scratchpads.numbat]
    command = "alacritty --class scratchpad -e numbat"
    margin = 50
    animation = "fromTop"

    [scratchpads.musikcube]
    command = "alacritty --class scratchpad -e musikcube"
    margin = 50

    [scratchpads.btm]
    command = "alacritty --class scratchpad -e btm"
    margin = 50
    animation = "fromLeft"

    [scratchpads.pavucontrol]
    command = "pavucontrol"
    margin = 50
    unfocus = "hide"
    animation = "fromTop"
  '';

 home.file.".config/libinput-gestures.conf".text = ''
    gesture swipe up 3	hyprctl dispatch hycov:toggleoverview
    gesture swipe down 3	nwggrid-wrapper

    gesture swipe right 3	hyprnome
    gesture swipe left 3	hyprnome --previous
    gesture swipe up 4	hyprctl dispatch movewindow u
    gesture swipe down 4	hyprctl dispatch movewindow d
    gesture swipe left 4	hyprctl dispatch movewindow l
    gesture swipe right 4	hyprctl dispatch movewindow r
    gesture pinch in	hyprctl dispatch fullscreen 1
    gesture pinch out	hyprctl dispatch fullscreen 1
  '';

  services.udiskie.enable = true;
  services.udiskie.tray = "always";
  }
