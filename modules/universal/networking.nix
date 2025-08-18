{ config, lib, pkgs, ... }:
{
  options = {
    mods.universal.networking = {
      interfaces = lib.mkOption {
        type = lib.types.listOf (lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Name of the network interface (e.g., eth0, eth1)";
            };
            
            addresses = lib.mkOption {
              type = lib.types.listOf (lib.types.submodule {
                options = {
                  address = lib.mkOption {
                    type = lib.types.str;
                    description = "IP address";
                  };
                  
                  prefixLength = lib.mkOption {
                    type = lib.types.int;
                    description = "Subnet prefix length (e.g., 24 for /24)";
                  };
                };
              });

              description = "List of IP addresses with their prefix lengths for this interface";
            };

            useDHCP = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Use dhcp or not";
            };
          };
        });
        default = [];
        description = "List of network interfaces to configure";
      };

      gateway = lib.mkOption {
        type = lib.types.str;
        description = "Default gateway IP address";
      };

      nameservers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "8.8.8.8" "8.8.4.4" ];
        description = "List of DNS nameservers";
      };
    };
  };

  config = {
    networking.interfaces = lib.listToAttrs (
      map (iface: {
        name = iface.name;
        value = {
          ipv4.addresses = iface.addresses;
          useDHCP = iface.useDHCP;
        };
      }) config.mods.universal.networking.interfaces
    );
    
    networking.defaultGateway = config.mods.universal.networking.gateway;
    networking.nameservers = config.mods.universal.networking.nameservers;

    networking.hosts = {
      "10.7.0.51" = ["homelab"];
    };
  };
}
