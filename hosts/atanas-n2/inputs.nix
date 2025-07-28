{
  base = {
    hostname = "atanas-n2";
    arch = "aarch64-linux";
  };

  # Networking
  # Make sure to use the correct interface name for your system (e.g., eth0).

  # networking.interfaces.eno1.ipv4.addresses = [
  #   {
  #     address = "10.10.10.123";
  #     prefixLength = 24;
  #   }
  # ];
  # You will also likely need to configure a default gateway and DNS servers.
  # networking.defaultGateway = "10.10.10.1";
  # networking.nameservers = [ "1.1.1.1" ];

  modules = {
    k3s = {
      enable = true;
      init = true;
      token = builtins.readFile ../../secrets/k3s_token;
    };
  };
}

