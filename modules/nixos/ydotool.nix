{
  config,
  lib,
  settings,
  ...
}: {
  options.ydotool.enable = lib.my.mkDefaultTrueEnableOption ''
    ydotool ClI automation tool
  '';

  config = lib.mkIf config.ydotool.enable {
    programs.ydotool.enable = true;

    # Allow main user to use ydotool
    users.users.${settings.username}.extraGroups = ["ydotool"];
  };
}
