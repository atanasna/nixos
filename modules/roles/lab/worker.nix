{ config, lib, pkgs, ... }:
{
  imports = [
    ../../services/k3s.nix
  ];

  options = {
    mods.roles.lab.worker = {
      k3s = {
        init = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable k3s service for the node";
        };
        
        token = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Token to be used for cluster node authentication";
        };
      };
    };
  };

  config = {
    mods.services.k3s = {
      enable = true;
      init = config.mods.roles.lab.worker.k3s.init;
      token = config.mods.roles.lab.worker.k3s.token;
    };
  };
}


