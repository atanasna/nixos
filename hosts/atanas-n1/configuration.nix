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
                address = "10.7.0.51"; 
                prefixLength = 24; 
              }
            ];
          }
        ];
        gateway = "10.7.0.51";
        nameservers = [ "8.8.8.8" "4.4.4.4" ];
      };
      system = {
        hostname = "atanas-n1";
        arch = "aarch64-linux";
      };
    };
    roles = {
      lab.worker = {
        k3s = {
          init = true;
          token = builtins.readFile ../../secrets/k3s_token;
        };
      };
    };
  };
}


