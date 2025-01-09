{device ? throw "Set this to your device, e.g. /dev/sda", ...}: {
  disko.devices = {
    disk.main = {
      inherit device;
      type = "disk";
      content = {
	type = "gpt";
	partitions = {
	  ESP = {
	    size = "512M";
	    type = "EF00";
	    content = {
	      type = "filesystem";
	      format = "vfat";
	      mountpoint = "/boot";
	      mountOptions = ["umask=0077"];
	    };
	  };
	  luks = {
	    size = "100%";
	    content = {
	      type = "luks";
	      name = "crypted";
	      passwordFile = "/tmp/secret.key";
	      settings.allowDiscards = true;
	      content = {
		type = "btrfs";
		extraArgs = ["-f"];
		subvolumes = {
		  "/root" = {
		    mountpoint = "/";
		    mountOptions = ["compress=zstd" "discard=async" "noatime"];
		  };

		  "/persist" = {
		    mountpoint = "/persist";
		    mountOptions = ["subvol=persist" "compress=zstd" "discard=async" "noatime"];
		  };

		  "/nix" = {
		    mountpoint = "/nix";
		    mountOptions = ["subvol=nix" "compress=zstd" "discard=async" "noatime"];
		  };

		  "/swap" = {
		    mountpoint = "/.swapvol";
		    swap.swapfile.size = "8G";
		  };
		};
	      };
	    };
	  };
	};
      };
    };
  };
}
