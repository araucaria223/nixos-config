{
  config,
  lib,
  settings,
  ...
}: {
  options.impermanence = {
    enable = lib.my.mkDefaultTrueEnableOption "impermanence";
    btrfs = lib.mkOption {
      default = false;
      example = true;
      description = ''
        Whether the system is using btrfs for impermanence
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.impermanence.enable {
    # Script to delete / recursively on reboot
    boot.initrd = lib.mkIf config.impermanence.btrfs {
      postDeviceCommands = lib.mkAfter ''
        mkdir /btrfs_tmp
        mount /dev/root_vg/root /btrfs_tmp
        if [[ -e /btrfs_tmp/root ]]; then
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
            mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
        fi

        delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                delete_subvolume_recursively "/btrfs_tmp/$i"
            done
            btrfs subvolume delete "$1"
        }

        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
            delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /btrfs_tmp/root
        umount /btrfs_tmp
      '';
    };

    fileSystems."/persist".neededForBoot = true;
    # Specify files & directories to keep on reboot
    environment.persistence."/persist/system" = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/etc/ssh"
        "/var/lib/systemd/coredump"
      ];
    };

    # Set correct permissions for home impermanence
    systemd.tmpfiles.rules = let
      username = config.users.users.${settings.username}.name;
    in [
      "d /persist/home/ 177 root root -"
      "d /persist/home/${username} 0770 ${username} users -"
    ];

    programs.fuse.userAllowOther = true;

    # Disable useradd and groupadd commands
    users.mutableUsers = lib.mkDefault false;

    system.etc.overlay = {
      enable = true;
      # To do: resolve issue with automatic-timezoned when set to true
      mutable = true;
    };
  };
}
