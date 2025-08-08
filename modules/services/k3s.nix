{ config, lib, pkgs, ... }:
{
  options = {
    mods.services.k3s = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable k3s service for the node";
      };

      init = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "This initializes the cluster and, should be true for the first node in the cluster";
      };
      
      token = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Token to be used for cluster node authentication";
      };

      clusterAddress = lib.mkOption {
        type = lib.types.str;
        default = "homelab";
        description = "This is the FQDN of the cluster";
      };

    };
  };

  config = lib.mkIf config.mods.services.k3s.enable {
    services.openiscsi = {
      enable = true;
      name = "iqn.2020-08.org.linux-iscsi:${config.networking.hostName}";
    };

    services.k3s = {
      enable = true;
      role = "server";
      token = config.mods.services.k3s.token;
      clusterInit = config.mods.services.k3s.init;
      serverAddr = (if config.mods.services.k3s.init then "" else "https://${config.mods.services.k3s.clusterAddress}:6443");
      extraFlags = toString ([
       "--write-kubeconfig-mode \"0644\""
       # "--disable servicelb"
       "--disable traefik"
       "--disable local-storage"
      ]);
    };
  };
}

