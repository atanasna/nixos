{ config, lib, pkgs, ... }:
{
  mods = {
    universal = {
      networking = {
        interfaces = [
          {
            name = "enp0s1";
            addresses = [
              { 
                address = "10.7.0.52"; 
                prefixLength = 24; 
              }
            ];
          }
        ];
        gateway = "10.7.0.1";
        nameservers = [ "8.8.8.8" "4.4.4.4" ];
      };
      system = {
        hostname = "atanas-n2";
        arch = "aarch64-linux";
      };
    };
    roles = {
      lab.worker = {
        k3s = {
          init = false;
          token = builtins.readFile ../../secrets/k3s_token;
        };
      };
    };
  };
}



