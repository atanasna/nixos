{ config, lib, pkgs, ... }:
{

  mods = {
    general = {
      hostname = "atanas-n1";
      arch = "aarch64-linux";
    }
    roles.lab.worker = {
      k3s = {
        init = true;
        token = builtins.readFile ../../secrets/k3s_token;
      };
    };
  };
}


