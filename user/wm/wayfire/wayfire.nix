{ config, lib, pkgs, userSettings, fetchurl, ... }:
let
  cubeBackgroundUrl = builtins.readFile (./lib/cubeimgurl.txt);
  cubeBackgroundSha256 = builtins.readFile (./lib/cubeimgsha256.txt);
in {
  lib.cubeImage = pkgs.fetchurl {
    url = cubeBackgroundUrl;
    sha256 = cubeBackgroundSha256;
  };


  imports = [
    ../../app/terminal/alacritty.nix
    ../../app/terminal/kitty.nix
    (import ../../app/dmenu-scripts/networkmanager-dmenu.nix {
      dmenu_command = "fuzzel -d";
      inherit config lib pkgs;
    })
    ./lib/waybar.nix
    ./lib/fuzzel.nix
  ];

 #home.file.".config/wf-shell.ini".source = ./wf-shell.ini;

  gtk.cursorTheme = {
    package = pkgs.bibata-cursors;
    name = if (config.stylix.polarity == "light") then "Bibata-Modern-Classic" else "Bibata-Modern-Ice";
    size = 24;
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
   kanshi
   mako
   wlsunset
   swayidle
   wofi
   swaylock
   wlogout
   grim
   slurp
   swaybg
   pamixer
   playerctl
   pavucontrol
   wev
   libsForQt5.qt5.qtwayland
   qt6.qtwayland
   xdg-utils
   xdg-desktop-portal
   xdg-desktop-portal-gtk
   xdg-desktop-portal-wlr
   xdg-desktop-portal-shana
   xdg-desktop-portal-gnome
   xdg-desktop-portal-hyprland
 ];
 home.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Wayfire";

    GDK_BACKEND = "wayland";
   #WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    MOZ_DISABLE_RDD_SANDBOX = 1;
    MOZ_ENABLE_WAYLAND = 1;

   #WLR_NO_HARDWARE_CURSORS = 1;
   #__GLX_VENDOR_LIBRARY_NAME = "nvidia";
   #GBM_BACKEND = "nvidia-drm";
   #LIBVA_DRIVER_NAME = "nvidia";
 };
 home.file.".config/wayfire.ini".text = ''
 # General -----------------------------
  [autostart]
    outputs = kanshi
    dbus = dbus-update-activation-environment DISPLAY XAUTHORITY WAYLAND_DISPLAY:
    background = ~/.swaybg-stylix
    emacs = emacs --daemon
    network = nm-applet
    bluetooth = blueman-applet
    syncthing = GOMAXPROC=1 syncthing --no-browser
    protonmail = protonmail-bridge --noninteractive
    dropbox = dropbox start
    waybar = waybar

    autostart_wf_shell = false


  [command]
    binding_terminal = <super> KEY_ENTER
    command_terminal = ${userSettings.term}

    binding_launcher = <super> KEY_E
    command_launcher = fuzzel

    binding_emacs = <super> KEY_A
    command_emacs = ${userSettings.spawnEditor}

    binding_browser = <super> KEY_S
    command_browser = ${userSettings.browser}

    binding_network = <super> KEY_I
    command_network = networkmanager_dmenu

    repeatable_binding_volume_up = KEY_VOLUMEUP
    command_volume_up = pamixer -i 5
    repeatable_binding_volume_down = KEY_VOLUMEDOWN
    command_volume_down = pamixer -d 5
    binding_skip = KEY_NEXTSONG
    command_skip = playerctl next
    binding_prev = KEY_PREVIOUSSONG
    command_prev = playerctl prev
    binding_pause = KEY_PLAYPAUSE
    command_pause = playerctl play-pause

  [core]
    plugins = \
      alpha animate autostart \
      blur \
      command cube \
      decoration \
      expo \
      fast-switcher fisheye foreign-toplevel \
      grid gtk-shell \
      idle invert \
      move \
      oswitch output-switcher \
      place preserve-output \
      resize \
      shortcuts-inhibit switcher simple-tile scale \
      vswitch vswipe \
      wayfire-shell window-rules wm-actions wobbly wrot \
      zoom

   #  Close focused window.
    close_top_view = <super> KEY_Q | <alt> KEY_F4

   #  Workspace arranged into a grid of: width x height. Default is 3x3.
    vwidth = 3
    vheight = 3

   #  Prefer client-side decoration or server-side decoration.
    prefered_decoration_mode = client

   #  Enable xwayland
    xwayland = true


  [input]
    xkb_layout = us
   #xkb_variant = dvorak
   #xkb_options = caps:escape

    kb_repeat_delay = 350
    kb_repeat_rate = 50

    mouse_accel_profile = flat

    cursor_theme = ${config.gtk.cursorTheme.name}
    cursor_size = ${builtins.toString config.gtk.cursorTheme.size}


  [output]


  [workarounds]



 # Window Management -------------------
  [fast-switcher]
    activate = <alt> <shift> KEY_TAB

  [grid]
   #  Animation duration.
    duration = 300
    type = wobbly

    slot_tl = <super> KEY_KP7
    slot_t = <super> KEY_KP8 | <super> KEY_UP
    slot_tr = <super> KEY_KP9
    slot_l = <super> KEY_KP4 | <super> KEY_LEFT
    slot_c = <super> KEY_KP5
    slot_r = <super> KEY_KP6 | <super> KEY_RIGHT
    slot_bl = <super> KEY_KP1
    slot_b = <super> KEY_KP2 | <super> KEY_DOWN
    slot_br = <super> KEY_KP3
    restore = <super> KEY_KP0


  [move]
    activate = <super> BTN_LEFT

    enable_snap = true
    enable_snap_off = true

    snap_threshold = 10
    snap_off_threshold = 30

  [place]
    mode = center

  [preserve-output]


  [simple-tile]
    button_move = <super> BTN_LEFT
    button_resize = <super> BTN_RIGHT

    key_toggle = <super> KEY_T

    inner_gap_size = 5
    outer_horiz_gap_size = 10
    outer_vert_gap_size = 10

  [switcher]
    next_view = <alt> KEY_TAB
    prev_view = <alt> KEY_APOSTROPHE

    speed = 500

    thumbnail_scale = 1.0

  [resize]
    activate = <super> BTN_RIGHT

  [wm-actions]
    toggle_fullscreen = <super> <shift> KEY_SPACE
    toggle_maximize = <super> KEY_SPACE

    toggle_always_on_top = <super> KEY_Y
    toggle_sticky = <super> <shift> KEY_Y

 # Accessibility -----------------------
  [invert]
    toggle = <super> <ctrl> <shift> KEY_I

  [zoom]
    modifier = <super> <ctrl>
    smoothing_duration = 300
    speed = 0.01

 # Desktop -----------------------------
  [alpha]
    modifier = <super> <alt>
    min_value = 0.1

  [cube]
    activate = <super> <ctrl> <shift> BTN_LEFT
    background_mode = skydome
    skydome_texture = ${config.lib.cubeImage}
    zoom = 0.1

  # deform = cylinder

  [expo]
    toggle = <super>

  [idle]


  [output-switcher]


  [scale]
    toggle = <super> KEY_P
    toggle_all = <super> <shift> KEY_P
  # Window Rules
  [window-rules]

  # Viewport Switcher
  [vswitch]
    binding_1 = <super> KEY_1
    binding_2 = <super> KEY_2
    binding_3 = <super> KEY_3
    binding_4 = <super> KEY_4
    binding_5 = <super> KEY_5
    binding_6 = <super> KEY_6
    binding_7 = <super> KEY_7
    binding_8 = <super> KEY_8
    binding_9 = <super> KEY_9

    with_win_1 = <super> <shift> KEY_1
    with_win_2 = <super> <shift> KEY_2
    with_win_3 = <super> <shift> KEY_3
    with_win_4 = <super> <shift> KEY_4
    with_win_5 = <super> <shift> KEY_5
    with_win_6 = <super> <shift> KEY_6
    with_win_7 = <super> <shift> KEY_7
    with_win_8 = <super> <shift> KEY_8
    with_win_9 = <super> <shift> KEY_9

    send_win_1 = <super> <ctrl> KEY_1
    send_win_2 = <super> <ctrl> KEY_2
    send_win_3 = <super> <ctrl> KEY_3
    send_win_4 = <super> <ctrl> KEY_4
    send_win_5 = <super> <ctrl> KEY_5
    send_win_6 = <super> <ctrl> KEY_6
    send_win_7 = <super> <ctrl> KEY_7
    send_win_8 = <super> <ctrl> KEY_8
    send_win_9 = <super> <ctrl> KEY_9

  # Viewport swipe
  [vswipe]

  # Workspace sets
  [wsets]


 # Effects -----------------------------
  [animate]
    close_animation = zoom

    open_animation = zoom

  [blur]

  
  [decoration]
    font = ${userSettings.font}


  [fisheye]
    toggle = <super> <ctrl> KEY_P
    zoom = 8.0
    radius = 600

  [wobbly]

  [window-rotate]

 '';
}
