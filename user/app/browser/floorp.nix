{ pkgs, userSettings, ... }:

{
  # Module installing  as default browser
  home.packages = [ pkgs.floorp ];

  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.floorp}/bin/floorp";
  };

  home.file.".floorp/floorp.overrides.cfg".text = ''
    defaultPref("font.name.serif.x-western","''+userSettings.font+''");

    defaultPref("font.size.variable.x-western",20);
    defaultPref("browser.toolbars.bookmarks.visibility","toggle");
    defaultPref("privacy.resisttFingerprinting.letterboxing", true);
    defaultPref("network.http.referer.XOriginPolicy",2);
    defaultPref("privacy.clearOnShutdown.history",false);
    defaultPref("privacy.clearOnShutdown.downloads",true);
    defaultPref("privacy.clearOnShutdown.cookies",false);
    defaultPref("gfx.webrender.software.opengl",false);
    defaultPref("webgl.disabled",true);
    defaultPref("gfx.webrender.all",true);
    defaultPref("layout.css.backdrop-filter.enabled",true);
    defaultPref("layout.css.backdrop-filter.enabled-force",true);
    defaultPref("toolkit.legacyUserProfileCustomizations.stylesheets",true);
    defaultPref("svg.context-properties.content.enabled",true);
    defaultPref("layout.css.color-mix.enabled",true);
    pref("font.name.serif.x-western","''+userSettings.font+''");

    pref("font.size.variable.x-western",20);
    pref("browser.toolbars.bookmarks.visibility","toggle");
    pref("privacy.resisttFingerprinting.letterboxing", true);
    pref("network.http.referer.XOriginPolicy",2);
    pref("privacy.clearOnShutdown.history",false);
    pref("privacy.clearOnShutdown.downloads",true);
    pref("privacy.clearOnShutdown.cookies",false);
    pref("gfx.webrender.software.opengl",false);
    pref("webgl.disabled",true);
    pref("gfx.webrender.all",true);
    pref("layout.css.backdrop-filter.enabled",true);
    pref("layout.css.backdrop-filter.enabled-force",true);
    pref("toolkit.legacyUserProfileCustomizations.stylesheets",true);
    pref("svg.context-properties.content.enabled",true);
    pref("layout.css.color-mix.enabled",true);
    '';

  xdg.mimeApps.defaultApplications = {
  "text/html" = "floorp.desktop";
  "x-scheme-handler/http" = "floorp.desktop";
  "x-scheme-handler/https" = "floorp.desktop";
  "x-scheme-handler/about" = "floorp.desktop";
  "x-scheme-handler/unknown" = "floorp.desktop";
  };

}
