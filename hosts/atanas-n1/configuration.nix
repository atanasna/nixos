{ config, lib, pkgs, ... }:
{

  mods = {
    roles.lab.worker = {
      k3s = {
        init = true;
        token = builtins.readFile ../../secrets/k3s_token;
      };
    };
  };
}


