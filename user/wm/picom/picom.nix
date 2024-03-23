{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    picom
  ];

  nixpkgs.overlays = [
    (final: prev:
      {
        picom = prev.picom.overrideAttrs (oldAttrs: rec {
        #version = "unstable-2021-10-23"; # Doesn't matter as far as I know
        src = prev.fetchFromGitHub {
          owner = "pijulius";
          repo = "picom";
          rev = "982bb43e5d4116f1a37a0bde01c9bda0b88705b9";
          sha256 = "sha256-YiuLScDV9UfgI1MiYRtjgRkJ0VuA1TExATA2nJSJMhM=";
        };
        # Build dependencies
        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
            final.meson
            final.cmake
            final.pcre
            ];

        meta = with builtins.lib; {
          description = "A fork of picom featuring better animations";
          homepage = "https://github.com/pijulius/picom";
        };
        });
      }
    )
  ];

  home.file.".config/picom/picom.conf".source = ./picom.conf;
}
