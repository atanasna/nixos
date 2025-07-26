{ config, lib, pkgs, ... }:
{

  mods = {
    general = {
      hostname = "atanas-n2";
      arch = "aarch64-linux";
    };
    roles.lab.worker = {
      k3s = {
        init = false;
        token = builtins.readFile ../../secrets/k3s_token;
      };
    };
  };
}


