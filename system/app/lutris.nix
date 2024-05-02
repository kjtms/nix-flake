{ lib, pkgs, stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation rec {
    pname = "lutris";
    version = "v0.5.17";

    src = fetchFromGitHub {
      owner = "lutris";
      repo = "lutris";
      rev = "4bc0f830e87483782477f3d97d75bf1a018fc644";
      sha256 = null;
    };
    doCheck = true;
}
