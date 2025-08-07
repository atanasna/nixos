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
                address = "192.168.66.12"; 
                prefixLength = 24; 
              }
            ];
          }
        ];
        gateway = "192.168.66.1";
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



