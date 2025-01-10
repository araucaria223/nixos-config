{
  config,
  lib,
  settings,
  ...
}: {
  options.plymouth.enable = lib.my.mkDefaultTrueEnableOption ''
    plymouth boot splash screen
  '';

  config = lib.mkIf config.plymouth.enable {
    boot = {
      plymouth.enable = true;
      consoleLogLevel = 0;
      initrd = {
        verbose = false;
        # Start systemd at stage 1 (for luks)
        systemd.enable = true;
      };

      # Silent boot options
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
        "vt.global_cursor_default=0"
      ];

      loader.timeout = 0;
    };

    services.getty = {
      autologinUser = settings.username;
      autologinOnce = true;
      loginProgram = "${config.programs.hyprland.package}/bin/Hyprland";
    };
  };
}
