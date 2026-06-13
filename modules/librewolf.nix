_: {
  flake.modules.homeManager.librewolf =
    {
      config,
      lib,
      inputs,
      pkgs,
      ...
    }:
    let
      masterScrollScale = 100;
      librewolfScrollScale = builtins.ceil (masterScrollScale * 0.2);
      primaryBackgroundOpacity = 0.5;
      primaryColorHex = "#BE2C20";
    in
    {
      options.my.home.librewolf = {
        overrides = lib.mkOption {
          type = lib.types.attrs;
          default = { };
        };
        scrollScale = lib.mkOption {
          type = lib.types.int;
          default = librewolfScrollScale;
        };
      };

      config = {
        programs = {
          librewolf = lib.recursiveUpdate {
            enable = true;
            policies = {
              Cookies = {
                Allow = [
                  "https://duckduckgo.com/"
                ];
                Behavior = "reject-tracker-and-partition-foreign";
                BehaviorPrivateBrowsing = "reject-tracker-and-partition-foreign";
                Locked = false;
              };
            };
            profiles = {
              default = {
                containersForce = true;
                extensions = {
                  force = true;
                  packages =
                    with inputs.nur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.repos.rycee.firefox-addons; [
                      darkreader
                      proton-pass
                      sponsorblock
                      ublock-origin
                      youtube-nonstop
                    ];
                  settings = {
                    "uBlock0@raymondhill.net" = {
                      force = true;
                      settings = {
                        user-filters = ''
                          duckduckgo.com##.header--aside__item--hidden-lg.header--aside__item
                          duckduckgo.com##.TccjmKV6RraCaCw5L9gd
                          ||accounts.google.com/gsi/$frame
                          www.reddit.com###credential_picker_container
                          www.reddit.com##.mb-md.mx-md.flex.justify-self-end.legal-links
                          chatgpt.com##.mt-2.m-4
                          chatgpt.com##.rtl\:translate-x-1\/2.ltr\:-translate-x-1\/2.lg\:start-1\/2.gap-2.items-center.flex-col.flex.start-0.absolute.pointer-events-none
                        '';
                      };
                    };
                  };
                };
                search = {
                  force = true;
                };
                settings = {
                  "browser.download.autohideButton" = true;
                  "browser.newtabpage.activity-stream.showSearch" = false;
                  "browser.tabs.allow_transparent_browser" = true;
                  "browser.uiCustomization.state" = {
                    "currentVersion" = 23;
                    "placements" = {
                      "PersonalToolbar" = [
                        "personal-bookmarks"
                      ];
                      "TabsToolbar" = [
                        "tabbrowser-tabs"
                        "new-tab-button"
                        "alltabs-button"
                      ];
                      "nav-bar" = [
                        "back-button"
                        "forward-button"
                        "stop-reload-button"
                        "urlbar-container"
                        "downloads-button"
                        "unified-extensions-button"
                      ];
                      "toolbar-menubar" = [
                        "menubar-items"
                      ];
                      "unified-extensions-area" = [
                        "addon_darkreader_org-browser-action"
                        "78272b6fa58f4a1abaac99321d503a20_proton_me-browser-action"
                        "sponsorblocker_ajay_app-browser-action"
                        "ublock0_raymondhill_net-browser-action"
                        "_0d7cafdd-501c-49ca-8ebb-e3341caaa55e_-browser-action"
                      ];
                      "vertical-tabs" = [ ];
                      "widget-overflow-fixed-list" = [ ];
                    };
                  };
                  "browser.urlbar.showSearchTerms.enabled" = false;
                  "extensions.autoDisableScopes" = 0;
                  "general.autoScroll" = true;
                  "middlemouse.paste" = false;
                  "mousewheel.default.delta_multiplier_x" = config.my.home.librewolf.scrollScale;
                  "mousewheel.default.delta_multiplier_y" = config.my.home.librewolf.scrollScale;
                  "mousewheel.default.delta_multiplier_z" = config.my.home.librewolf.scrollScale;
                  "mousewheel.default.with_alt.delta_multiplier_x" = config.my.home.librewolf.scrollScale;
                  "mousewheel.default.with_alt.delta_multiplier_y" = config.my.home.librewolf.scrollScale;
                  "mousewheel.default.with_alt.delta_multiplier_z" = config.my.home.librewolf.scrollScale;
                  "mousewheel.default.with_control.delta_multiplier_x" = config.my.home.librewolf.scrollScale;
                  "mousewheel.default.with_control.delta_multiplier_y" = config.my.home.librewolf.scrollScale;
                  "mousewheel.default.with_control.delta_multiplier_z" = config.my.home.librewolf.scrollScale;
                  "mousewheel.default.with_meta.delta_multiplier_x" = config.my.home.librewolf.scrollScale;
                  "mousewheel.default.with_meta.delta_multiplier_y" = config.my.home.librewolf.scrollScale;
                  "mousewheel.default.with_meta.delta_multiplier_z" = config.my.home.librewolf.scrollScale;
                  "mousewheel.default.with_shift.delta_multiplier_x" = config.my.home.librewolf.scrollScale;
                  "mousewheel.default.with_shift.delta_multiplier_y" = config.my.home.librewolf.scrollScale;
                  "mousewheel.default.with_shift.delta_multiplier_z" = config.my.home.librewolf.scrollScale;
                  "privacy.fingerprintingProtection" = true;
                  "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme";
                  "privacy.resistFingerprinting" = false;
                  "privacy.sanitize.sanitizeOnShutdown" = false;
                  "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                };
                userChrome = ''
                  /* Clear all browser content background */
                  #main-window,
                  #browser,
                  #appcontent,
                  #tabbrowser-tabbox,
                  #tabbrowser-tabpanels,
                  browser,
                  .browserContainer {
                    background: none !important;
                  }

                  /* Hide navigator toolbox with bookmarks bar unless urlbar is focused or open */
                  #navigator-toolbox:has(
                    #PersonalToolbar[collapsed]
                  ):not(:has(
                    #urlbar[focused],
                    #urlbar[open]
                  )) {
                    display: none !important;
                  }

                  /* Translucent theme */
                  #navigator-toolbox,
                  #browser:not(.browser-toolbox-background) {
                    background-color: rgba(0, 0, 0, ${builtins.toString primaryBackgroundOpacity}) !important;
                  }
                  #navbar,
                  #tabbrowser-tabpanels {
                    background-color: transparent !important;
                  }
                  .browser-toolbar {
                    @media not -moz-pref("sidebar.verticalTabs") {
                      &:not(.browser-titlebar) {
                        background-color: transparent !important;
                      }
                    }
                  }
                  #navigator-toolbox,
                  #urlbar-background {
                    border: none !important;
                  }

                  /* Make selected tabs translucent */
                  .tab-background {
                    &:is([selected], [multiselected]) {
                      background-color: rgba(0, 0, 0, 0.5) !important;
                    }
                  }

                  /* Make the tab bar slimmer */
                  #TabsToolbar-customization-target,
                  .tab-stack {
                    max-height: 24px !important;
                  }
                  #tabbrowser-tabs,
                  .tab-background {
                    min-height: 0 !important;
                  }
                  .tab-content {
                    padding-right: 4px !important;
                  }

                  /* Make tabs fill up the little remaining space above and below them */
                  .tab-background {
                    margin-block: 0 !important;
                  }

                  /* Remove gaps between tabs and new tab button, and between All Tabs and Exit button */
                  .tabbrowser-tab {
                    padding-left: 0 !important;
                    padding-right: 0 !important;
                  }
                  toolbar .toolbarbutton-1 {
                    padding: 0 !important;
                  }

                  /* Remove spacer between All Tabs button and Exit button */
                  .titlebar-spacer {
                    display: none !important;
                  }

                  /* Make URL search results background dark but still translucent */
                  #urlbar-background,
                  #searchbar {
                    background-color: rgba(0, 0, 0, 0.3) !important;
                  }
                  #urlbar:is([focused], [open]) >
                    #urlbar-background,
                    #searchbar:focus-within {
                      background-color: rgba(0, 0, 0, 0.5) !important;
                    }
                  .urlbar:is([focused], [open]) >
                    .urlbar-background,
                    #searchbar:focus-within {
                      background-color: rgba(0, 0, 0, 0.5) !important;
                    }

                  /* Make selected option in URL suggestions highlighted in a light color */
                  .urlbarView-row {
                    &[selected] {
                      background-color: rgba(205, 205, 205, 0.3) !important;
                    }
                  }

                  /* Make URL bar dropdown selection blur background */
                  :root:has(#urlbar[open]) #tabbrowser-tabpanels,
                  :root:has(#urlbar[open]) #PersonalToolbar {
                    filter: blur(4px) !important;
                  }

                  /* Make the Find in Page bar translucent */
                  .browserContainer > findbar {
                    background-color: transparent !important;
                  }

                  /* Remove tab icon from New Tab page */
                  .tabbrowser-tab[label="New Tab"] .tab-icon-image {
                    display: none !important;
                  }

                  /* Remove New Tab button */
                  #tabs-newtab-button,
                  #new-tab-button {
                    display: none !important;
                  }

                  /* Set accent color for various things */
                  .tab-background {
                    &[multiselected] {
                      outline-color: ${primaryColorHex} !important;
                    }
                  }
                  #TabsToolbar #firefox-view-button:focus-visible > .toolbarbutton-icon,
                  #tabbrowser-tabs[tablist-has-focus] .tabbrowser-tab.tablist-keyboard-focus > .tab-stack > .tab-background {
                    outline-color: ${primaryColorHex} !important;
                  }
                  toolbar .toolbarbutton-1 {
                    &:focus-visible {
                      & > .toolbarbutton-icon,
                      & > .toolbarbutton-text,
                      & > .toolbarbutton-badge-stack {
                        outline-color: ${primaryColorHex} !important;
                      }
                    }
                  }
                  "#urlbar-searchmode-switcher" {
                    &:focus-visible {
                      outline-color: ${primaryColorHex} !important;
                    }
                  }
                  #urlbar[focused]:not([suppress-focus-border]) > #urlbar-background,
                  #searchbar:focus-within {
                    outline-color: ${primaryColorHex} !important;
                  }
                  .urlbar-page-action {
                    &layoutxy:focus-visible {
                      outline-color: ${primaryColorHex} !important;
                    }
                  }
                  toolbarbutton.bookmark-item:not(.subviewbutton) {
                    &:focus-visible {
                      outline-color: ${primaryColorHex} !important;
                    }
                  }
                  *:focus::selection {
                    background-color: ${primaryColorHex} !important;
                  }
                '';
                userContent = ''
                  /* Override background color on New Tab page */
                  @-moz-document
                  url(about:newtab),
                  url(about:home),
                  url(about:config) {
                    :root {
                      --background-color-canvas: transparent !important;
                      --newtab-background-color: transparent !important;
                      --newtab-background-color-secondary: transparent !important;
                    }
                  }
                  /* New Private Tab Transparent Background */
                  @-moz-document
                  url(about:privatebrowsing) {
                    :root {
                      background-color: transparent !important;
                    }
                    .private {
                      display: none !important;
                    }
                  }

                  /* Set selection highlight color */
                  ::selection {
                    background-color: ${primaryColorHex} !important;
                  }

                  /* Remove the Personalize button on the new tab page */
                  .personalizeButtonWrapper {
                    display: none !important;
                  }

                  @-moz-document
                  domain(duckduckgo.com) {
                    /* DuckDuckGo Transparent Background */
                    #header_wrapper,
                    html,
                    body,
                    .site-wrapper.js-site-wrapper,
                    .tV0DEo5a5LUrl8Piw6Ao._2iQrmxmcSVuOHpCus2L,
                    .Yf9bk3ILYs4b7K_9B8tY,
                    .TfqyIdnJYa_EMwr0UYGw,
                    .tuO47VfYLXtuDpBJSjrV {
                      background-color: transparent !important;
                    }
                    .DrcPyihFGyKMlg6lpwsa::before,
                    .XvPRmQVeIoCP5lQhICTv.ofDl_1VxUG_EKc3b9E3x::before,
                    .ph1UFslrkUMqoYJEtp3t.hnKIeVb9Fi3YMCZAeQvR::before,
                    .ph1UFslrkUMqoYJEtp3t.hnKIeVb9Fi3YMCZAeQvR::after {
                      display: none !important;
                    }
                    /* Transparent Search Summary Title Card */
                    .O9Ipab51rBntYb0pwOQn {
                      background-color: rgba(0, 0, 0, 0.3) !important;
                      border: none !important;
                    }
                    /* Transluscent Search Assist and Ask Duck.ai */
                    .nKc6YUBojXXvgstPGALT::after,
                    .uGue0l8AIZlLfp4gW7vu,
                    .AvAURxrcviI0tNootU1F {
                      background-color: rgba(0, 0, 0, 0.3) !important;
                    }
                    /* Transparent Images Filters */
                    .ph1UFslrkUMqoYJEtp3t.AnI0juSKrY9ML7JPA2HT {
                      background-color: transparent !important;
                      border: none !important;
                    }
                    .ph1UFslrkUMqoYJEtp3t.AnI0juSKrY9ML7JPA2HT.bpmtqMMvOah3BsmgaZwn,
                    .ph1UFslrkUMqoYJEtp3t.AnI0juSKrY9ML7JPA2HT .FYE8sDoV8K7xL0Tpn5TR::before,
                    .ph1UFslrkUMqoYJEtp3t.AnI0juSKrY9ML7JPA2HT .FYE8sDoV8K7xL0Tpn5TR::after {
                      display: none !important;
                    }
                    /* Disable Background When Opening Image in New Tab */
                    @media not print {
                      :root {
                        background: none !important;
                      }
                    }

                    /* DuckDuckGo Transparent Search Bar */
                    .T265XEcezvjUhK71U8pN.QsyijBlqupsaY11GFhnp {
                      background-color: rgba(0, 0, 0, 0.3) !important;
                    }
                    .set-header--floating .header-wrap, .set-header--floating .metabar {
                      display: none !important;
                    }

                    /* Remove DuckDuckGo Logo and Hamburger Menu */
                    #header-logo-wrapper,
                    .header--aside.js-header-aside,
                    .footer {
                      display: none !important;
                    }

                    /* Full Width Search Results */
                    html,
                    body,
                    .site-wrapper.js-site-wrapper {
                      min-width: 0 !important;
                    }
                    .header__search-wrap {
                      margin-left: 12px !important;
                      padding-left: 0 !important;
                    }
                    .qrc3T8W2PIYg9L63oA06.IlK3G8WDnnjkNGDV6qzo.h3EKGeHmRRkjbMqYfNUi.wuwdN2SgDOTwsnBO5PI7.rXBzGoYc_uM83jRoODrM.xWVFEW_kM7bYLASLNfsZ,
                    .qrc3T8W2PIYg9L63oA06.IlK3G8WDnnjkNGDV6qzo.zqdPZIKd0gTxkTPnBBos.h3EKGeHmRRkjbMqYfNUi.super-wide.ZU6fV5zAYhNqBrbePNMK.xWVFEW_kM7bYLASLNfsZ,
                    .A3jKQ60lBdG4Xl5HbK6_.h3EKGeHmRRkjbMqYfNUi.wuwdN2SgDOTwsnBO5PI7.rXBzGoYc_uM83jRoODrM.xWVFEW_kM7bYLASLNfsZ,
                    .A3jKQ60lBdG4Xl5HbK6_.h3EKGeHmRRkjbMqYfNUi.super-wide.ZU6fV5zAYhNqBrbePNMK.xWVFEW_kM7bYLASLNfsZ {
                      margin-left: 12px !important;
                    }
                    #header,
                    .aDtqDaYogch0DyrGTrX6 {
                      flex: 1 !important;
                      margin-right: 12px !important;
                      max-width: 100% !important;
                      width: 100% !important;
                    }

                    /* Hide Related Searches and Feedback Prompt */
                    .related-searches.t-m.at-bottom,
                    .gdzyb9PgLazLyi4DKK0O.js-react-sidebar.YL_aMfikzFszfcc4KLSh,
                    .js-react-news-sidebar.YL_aMfikzFszfcc4KLSh,
                    .QLnrpZotv4aJbXfgALkx {
                      display: none !important;
                    }
                    .At_VJ9MlrHsSjbfCtz2_.aDtqDaYogch0DyrGTrX6 {
                      max-width: 100% !important;
                    }

                    /* Make Videos Have Transparent Background but not always */
                    .SPtr__zhjMUpc8twp7PX.EX10Eet_6LNBv7McSqLf {
                      background-color: black !important;
                    }

                    /* Red Highlight Keyboard Selection */
                    .yQDlj3B5DI5YO8c8Ulio.jHKRD_8UMD51jfnKQ1LL {
                      background-color: rgba(77, 29, 24, 0.75) !important;
                      border: none !important;
                    }
                  }

                  /* Hide More Videos Recommendations on YouTube Video Pause */
                  .ytp-pause-overlay {
                    display: none !important;
                  }

                  /* Transparent YouTube */
                  @-moz-document
                  domain(youtube.com) {
                    html,
                    html[dark],
                    ytd-app,
                    #frosted-glass,
                    #background.ytd-masthead,
                    #full-bleed-container,
                    #page-header-container.ytd-tabbed-page-header,
                    #tabs-container.ytd-tabbed-page-header,
                    #page-header.ytd-tabbed-page-header,
                    #tabs-inner-container.ytd-tabbed-page-header,
                    ytd-feed-filter-chip-bar-renderer[component-style="FEED_FILTER_CHIP_BAR_STYLE_TYPE_CHANNEL_PAGE_GRID"] #chips-wrapper.ytd-feed-filter-chip-bar-renderer {
                      background: none !important;
                    }
                    #cinematic-shorts-scrim {
                      display: none !important;
                    }
                    ytd-shorts[anchored-panel-active] .navigation-container.ytd-shorts {
                      background: none !important;
                    }
                  }

                  /* Transparent Reddit */
                  @-moz-document
                  domain(reddit.com) {
                    /* Main transparent components */
                    html,
                    .grid-container,
                    .block,
                    #flex-left-nav-container,
                    #pdp-credit-bar,
                    .bg-neutral-background-weak,
                    .bg-neutral-background,
                    #pdp-comments-tree-sort-container,
                    #comment-tree {
                      background: none !important;
                    }

                    /* Transparent feed and remove image light boxes and backgrounds */
                    .post-background-image-filter {
                      display: none !important;
                    }
                    #post-image,
                    li[slot^="page-"] {
                      background: none !important;
                    }
                    .media-lightbox-img {
                      background: none !important;
                      border: none !important;
                    }
                    .pointer-events-none.rounded-4 {
                      border: none !important;
                    }
                    div[slot="post-media-container"] {
                      border-radius: 0 !important;
                    }
                    div[slot="recommendation-overlay"] {
                      display: none !important;
                    }
                    div[slot="post-media-container"] > .pointer-events-none {
                      display: none !important;
                    }
                    gallery-carousel > ul {
                      transition-property: none !important;
                    }
                  }

                  /* Transparent ChatGPT */
                  @-moz-document
                  domain(chatgpt.com) {
                    /* Transparent main area */
                    @layer base {
                      html, body {
                        background: none !important;
                      }
                    }
                    :root {
                      --bg-primary: transparent !important;
                    }

                    /* Transparent header and side bar */
                    #page-header,
                    #stage-slideover-sidebar,
                    .relative.flex.h-full.flex-col {
                      background: none !important;
                    }

                    /* Transparent chat boxes and other stuff */
                    @layer utilities {
                      .dark\:bg-\[\#303030\]:where(.dark, .dark *):not(:where(.dark .light, .dark .light *)),
                      .bg-\(--sidebar-bg\,var\(--bg-elevated-secondary\)\),
                      .bg-\(--sidebar-mask-bg\,var\(--bg-elevated-secondary\)\),
                      .bg-token-bg-elevated-primary,
                      .bg-token-bg-elevated-secondary,
                      .bg-token-main-surface-primary,
                      .bg-token-main-surface-secondary,
                      .bg-token-main-surface-tertiary,
                      .content-fade.single-line::after {
                        background: none !important;
                      }
                    }
                  }
                '';
              };
            };
          } config.my.home.librewolf.overrides;
        };
      };
    };
}
