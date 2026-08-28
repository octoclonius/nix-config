_: {
  flake.modules.nixos.routerOob = {
    boot = {
      kernelModules = [
        "iTCO_wdt"
        "iTCO_vendor_support"
      ];
      kernelParams = [
        "panic=1"
      ];
    };

    systemd = {
      settings = {
        Manager = {
          RebootWatchdogSec = "10m";
          RuntimeWatchdogSec = "30s";
        };
      };
    };

    # Intel AMT / vPro out-of-band management is configured in firmware, not
    # NixOS. After the router is stable, enter the MEBx setup during boot and:
    #   - enable AMT / vPro;
    #   - set a strong, unique AMT password;
    #   - note the AMT IP and MAC address;
    #   - configure BIOS to power on after AC loss.
  };
}
