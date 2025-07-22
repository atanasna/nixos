{ config, lib, pkgs, ... }:

{
  options.services.k3s = {
    enableModule = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable k3s service for the node";
    };

    tokenFile = lib.mkOption {
      type = lib.types.path;
      description = "File containing the k3s token";
    };
  };

  config = lib.mkIf config.services.k3s.enableModule {
    services.k3s = {
      enable = true;
      role = "server";
      tokenFile = config.services.k3s.tokenFile;
      extraFlags = toString ([
       "--write-kubeconfig-mode \"0644\""
       "--cluster-init"
       "--disable servicelb"
       "--disable traefik"
       "--disable local-storage"
      ] ++ (if config.networking.hostName == "atanas-nix-1" then [] else [
         "--server https://homelab-0:6443"
      ]));
      clusterInit = (config.networking.hostName == "atanas-nix-1");
    };
  };
}

