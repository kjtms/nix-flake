{ config, pkgs, userSettings, ... }:

{
  programs.git-credential-oauth.enable = true;
  programs.git = {
    enable = true;
    userName = userSettings.name;
    userEmail = userSettings.email;
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = userSettings.dotfilesDir;
    };
  };
}
