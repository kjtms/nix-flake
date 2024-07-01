{ pkgs, ... }:
{
  # Collection of useful CLI apps
  home.packages = with pkgs; [
    # I am an arch user by heart
    disfetch
    neofetch hyfetch
    starfetch
    octofetch onefetch
    onefetch
    cpufetch
    ipfetch
    pfetch

    # Funny little things
    lolcat uwuify
    cowsay
    cava
    cbonsai
    rsclock
    pipes-rs
    cmatrix
    hollywood
    sssnake
    vitetris

    figlet

    lf
    yazi

    #
    speedtest-rs
    gping
    fail2ban
    psi-notify

    killall
    libnotify
    timer
    brightnessctl
    gnugrep ripgrep
    gnused sd
    rsync
    unzip
    zip
    w3m
    pandoc
    hwinfo
    pciutils
    numbat
    (pkgs.writeShellScriptBin "airplane-mode" ''
      #!/bin/sh
      connectivity="$(nmcli n connectivity)"
      if [ "$connectivity" == "full" ]
      then
          nmcli n off
      else
          nmcli n on
      fi
    '')
    vim neovim
  ];
}
