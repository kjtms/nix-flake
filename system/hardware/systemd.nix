{ config, pkgs, ... }:

{
  services.journald.extraConfig = "SystemMaxUse=250M\nSystemMaxFiles=10";
  services.journald.rateLimitBurst = 800;
  services.journald.rateLimitInterval = "5s";

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutSec = 10;
      };
    };
  };
}
