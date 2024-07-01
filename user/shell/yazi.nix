{ config, lib, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    settings = {
      manager = {
        ratio = [ 1 3 4 ];
        sort_by = "natural";
        sort_sensitive = true;
        sort_reverse = false; # list files in reverse order
        sort_dir_first = true; # list directories before files
        linemode = "mtime"; # displays certain informations on the right side of entry ## size only works if sort_by="size"
        show_symlink = true; # show path of symlink
        scrolloff = 10; # amount of entries to show above/below the cursor
      };
      preview = {
      };
      opener = {
      };
      open = {
      };
      tasks = {
      };
      plugin = {
      };
      input = {
      };
      select = {
      };
      which = {
      };

    };
    keymap = {


    };
    theme = {

    };

  };
  home.packages = with pkgs; [
    yazi

    ffmpegthumbnailer
    unar
    jq
   #poppler
    fd
    ripgrep
    fzf
    zoxide
    wl-clipboard
    exiftool
  ];
}
