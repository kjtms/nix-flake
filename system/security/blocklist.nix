{ config, blocklist-hosts, pkgs, ... }:

let blocklist = builtins.readFile "${blocklist-hosts}/alternates/gambling/hosts";
in
{
  networking.extraHosts = ''
    "${blocklist}"
  '';
}
