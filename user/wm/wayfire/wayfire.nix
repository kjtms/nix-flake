{ config, lib, pkgs, userSettings, ... }:
let
  cubeBackgroundUrl = builtins.readFile (./lib/cubeimgurl.txt);
  cubeBackgroundSha256 = builtins.readFile (./lib/cubeimgsha256.txt);
in {
  lib.cubeImage = pkgs.fetchurl {
    url = cubeBackgroundUrl;
    sha256 = cubeBackgroundSha256;
  };

  home.file.".wayfire-cubeimage.png".source = config.lib.cubeImage;

  imports = [
    ../../app/terminal/alacritty.nix
    ../../app/terminal/kitty.nix
    (import ../../app/dmenu-scripts/networkmanager-dmenu.nix {
      dmenu_command = "fuzzel -d";
      inherit config lib pkgs;
    })
    ./lib/waybar.nix
    ./lib/fuzzel.nix
    ./lib/fnott.nix
  ];

 #home.file.".config/wf-shell.ini".source = ./wf-shell.ini;

  gtk.cursorTheme = {
    package = pkgs.bibata-cursors;
    name = if (config.stylix.polarity == "light") then "Bibata-Modern-Classic" else "Bibata-Modern-Ice";
    size = 24;
  };

  home.packages = with pkgs; [
    cairo
    freetype
    glm
    libdrm
    libevdev
    libGL
    libinput
    libjpeg
    libpng
    libxkbcommon
    libxml2
    pixman
    pkg-config
    wayland
    wayland-protocols
    wf-config
    wlroots

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
   hyprpaper
 ];
 home.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Wayfire";

    WAYFIRE_CONFIG_FILE = "/home/kjat/.dotfiles/user/wm/wayfire/conf.ini";

    GDK_BACKEND = "wayland";
    WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
    QT_QPA_PLATFORM = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    MOZ_DISABLE_RDD_SANDBOX = 1;
    MOZ_ENABLE_WAYLAND = 1;
 };

 home.file.".config/wayfire/wayfire.ini".source = ./conf.ini;
}
