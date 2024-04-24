{ pkgs, lib, config, ... }:

{
  options = {
    doas.enable = lib.mkEnableOption "enable doas";
  };

  config = lib.mkIf config.doas.enable {
    # disable sudo
    security.sudo.enable = false;
  
    security.doas = {
      enable = true;

      extraRules = [{
        # allows users to use doas
        groups = [ "wheel" ]; 

        # retains environment variables
        keepEnv = true;

        # allows running multiple commands after single verification
        persist = true;
      }];
    };
  };
}
