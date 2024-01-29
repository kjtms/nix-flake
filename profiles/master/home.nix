{ config, lib, pkgs, stdenv, fetchurl, nix-doom-emacs, stylix, username, email, dotfilesDir, theme, wm, browser, editor, spawnEditor, term, timezone, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = "/home/"+username;

  programs.home-manager.enable = true;

  imports = [
              nix-doom-emacs.hmModule
              stylix.homeManagerModules.stylix
              (./. + "../../../user/wm"+("/"+wm+"/"+wm)+".nix") # My window manager selected from flake
              ../../user/shell/sh.nix # My zsh and bash config
              ../../user/shell/cli-collection.nix # Useful CLI apps
              ../../user/bin/phoenix.nix # My nix command wrapper
              ../../user/app/doom-emacs/doom.nix # My doom emacs config
              ../../user/app/ranger/ranger.nix # My ranger file manager config
              ../../user/app/games/games.nix # various videogame apps
              ../../user/app/git/git.nix # My git config
              ../../user/app/keepass/keepass.nix # My password manager
              (./. + "../../../user/app/browser"+("/"+browser)+".nix") # My default browser selected from flake
              ../../user/app/virtualization/virtualization.nix # Virtual machines
              ../../user/app/flatpak/flatpak.nix # Flatpaks
              ../../user/style/stylix.nix # Styling and themes for my apps
              ../../user/lang/android/android.nix
              #../../user/lang/cc/cc.nix # C and C++ tools
              #../../user/lang/godot/godot.nix # Game development
              ../../user/pkgs/blockbench.nix # Blockbench
              ../../user/hardware/bluetooth.nix # Bluetooth
            ];

  home.stateVersion = "22.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # Core
    zsh
    alacritty
    brave
    git
    syncthing
    floorp

    # Office
    libreoffice-fresh
    mate.atril
    xournalpp
    glib
    newsflash
    gnome.nautilus
    gnome.seahorse
    gnome.gnome-maps
    gparted
    protonmail-bridge
    thunderbird
    #logseq #obsidian alternative

    wine
    bottles
    # The following requires 64-bit FL Studio (FL64) to be installed to a bottle
    # With a bottle name of "FL Studio"
    (pkgs.writeShellScriptBin "flstudio" ''
       #!/bin/sh
       if [ -z "$1" ]
         then
           bottles-cli run -b "FL Studio" -p FL64
           #flatpak run --command=bottles-cli com.usebottles.bottles run -b FL\ Studio -p FL64
         else
           filepath=$(winepath --windows "$1")
           echo \'"$filepath"\'
           bottles-cli run -b "FL Studio" -p "FL64" --args \'"$filepath"\'
           #flatpak run --command=bottles-cli com.usebottles.bottles run -b FL\ Studio -p FL64 -args "$filepath"
         fi
    '')
    (pkgs.makeDesktopItem {
      name = "flstudio";
      desktopName = "FL Studio 64";
      exec = "flstudio %U";
      terminal = false;
      type = "Application";
      mimeTypes = ["application/octet-stream"];
    })

    # Media
    gimp-with-plugins
    krita
    inkscape
    musikcube
    mpv
    yt-dlp
    #freetube
    blender
    #blockbench-electron
    #cura
    #obs-studio
    ffmpeg
    movit
    mediainfo
    libmediainfo
    mediainfo-gui
    audio-recorder
    deluge # TODO make deluge config a seperate .nix file under /app, a lot of customizing to be done
    armcord
    etcher
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-19.1.9"
  ];
  services.syncthing.enable = true;

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    music = "${config.home.homeDirectory}/Media/Music";
    videos = "${config.home.homeDirectory}/Media/Videos";
    pictures = "${config.home.homeDirectory}/Media/Pictures";
    templates = "${config.home.homeDirectory}/Templates";
    download = "${config.home.homeDirectory}/Downloads";
    documents = "${config.home.homeDirectory}/Documents";
    desktop = null;
    publicShare = null;
    extraConfig = {
      XDG_DOTFILES_DIR = "${config.home.homeDirectory}/.dotfiles";
      XDG_ARCHIVE_DIR = "${config.home.homeDirectory}/Archive";
      XDG_VM_DIR = "${config.home.homeDirectory}/Machines";
      XDG_ORG_DIR = "${config.home.homeDirectory}/Org";
      XDG_PODCAST_DIR = "${config.home.homeDirectory}/Media/Podcasts";
      XDG_BOOK_DIR = "${config.home.homeDirectory}/Media/Books";
      XDG_MOVIES_DIR = "${config.home.homeDirectory}/Media/Movies";
      XDG_GAME_DIR = "${config.home.homeDirectory}/Media/Games";
      XDG_GAME_SAVE_DIR = "${config.home.homeDirectory}/Media/Game Saves";
    };
  };
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;
  xdg.mimeApps.associations.added = {
    "application/octet-stream" = "flstudio.desktop;";
  };

  home.sessionVariables = {
    EDITOR = editor;
    SPAWNEDITOR = spawnEditor;
    TERM = term;
    BROWSER = browser;
  };

}
