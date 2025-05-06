{config, pkgs, inputs, ...}:

{

  home.file."firefox-userChrome" = {
    target = ".mozilla/firefox/solanum/chrome/removeButtons.css";
    source = ./removeButtons.css;
  };

  programs.firefox = {
    enable = true;
    profiles.solanum = {

      search.engines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };
        "Home Manager Options" = {
          urls = [{
            template = "https://home-manager-options.extranix.com/";
            params = [
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@hm" ];
        };
      };
      search.force = true;

      settings = {
      #general
        #open previous windows and tabs
        #open links in tabs instead of windows
        #confirm before quit
        #drm content
        #smooth scroll
        #control media
      #home
        #web search
        #shortcuts
      #search
        #default = google

        #search suggestions
          #before browsing history

        #bar
          #all except sponsors

        #shortcuts
          #wiki@w
          #nixos search@n
          #bookmarks*, tabs%, history^
      #privsec
        #strict
        #do not sell request
        #do not track request
        #no password manager
        #no autofill
        #block popups
        #warn when autoaddons
        #no extension reccomendations
        #block dangerous and deceptive
        #look into DNS over HTTP. default is probably fine
      };

      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
        auto-tab-discard
        darkreader
        decentraleyes
        firefox-translations
        indie-wiki-buddy
        keepassxc-browser
        noscript
        #open in vlc media player
        plasma-integration
        #popup blocker strict
        sponsorblock
        tab-session-manager
        #tampermonkey
        ublock-origin
      ];
      userChrome = ''
        @import "removeButtons.css";
      '';
    };
  };
}
