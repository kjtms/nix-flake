{ pkgs, ... }:
let

  # My shell aliases
  myAliases = {
    ls = "eza --icons -l -T -L=1";
    cat = "bat";
    htop = "btm";
    fd = "fd -Lu";
    w3m = "w3m -no-cookie -v";
   #neofetch = "disfetch";
    fetch = "disfetch";
    gitfetch = "onefetch";
    nhos = "nh os switch --hostname system --ask";
    nhome = "nh home switch --configuration user --ask";
  };
in
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = myAliases;
  };

  home.packages = with pkgs; [
    bat
    eza
    bottom
    fd
    bc
    direnv nix-direnv
    yazi
    zoxide
    carapace
    keychain
    thefuck
    broot
    atuin
  ] ++ (with nushellPlugins; [
    net
    gstat
    formats
  ]);
  programs.yazi.enableNushellIntegration = true;
  programs.eza.enableNushellIntegration = true;
  programs.zoxide.enableNushellIntegration = true;
  programs.carapace.enableNushellIntegration = true;
  services.gpg-agent.enableNushellIntegration = true;
  services.gpg-agent.enable = true;
  programs.keychain.enableNushellIntegration = true;
  programs.thefuck.enableNushellIntegration = true;
  programs.broot.enableNushellIntegration = true;
  programs.atuin.enableNushellIntegration = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.enableNushellIntegration = true;

  programs.nushell = {
    enable = true;
    shellAliases = myAliases;
    extraConfig = ''
      $env.config = {
        show_banner: false
        completions: {
          case_sensitive: false
          quick: true
          partial: true
          use_ls_colors: true
        }
        ls: {
          use_ls_colors: true
          clickable_links: true
        }
        error_style: "fancy"
        history: {
          max_size: 100_000
          sync_on_enter: true
          file_format: "plaintext"
        }
        filesize: {
          metric: true
          format: "auto"
        }
      }
    '';
  };
  programs.oh-my-posh = {
    enable = true;
    enableNushellIntegration = true;
    useTheme = "easy-term";
  };
}
