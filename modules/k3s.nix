{ config, lib, pkgs, ... }:

{
  options.services.k3s = {
    isEnable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable k3s service for the node";
    };

    isFirst = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "This should be true for the first node in the cluster that will initialize it";
    };
    
    token = lib.mkOption {
      type = lib.type.string;
      description = "Token to be used for cluster node authentication";
    };
  };

  config = lib.mkIf config.services.k3s.isEnable {
    services.k3s = {
      enable = true;
      role = "server";
      token = config.services.k3s.token;
      clusterInit = config.services.k3s.isFirst;
      serverAddr = (if not config.services.k3s.isFirst then "https://homelab:6443" else "");
      extraFlags = toString ([
       "--write-kubeconfig-mode \"0644\""
       "--disable servicelb"
       "--disable traefik"
       "--disable local-storage"
      ]);
    };
  };
}

