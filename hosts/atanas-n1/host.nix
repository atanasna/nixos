{
  # Base
  hostname = "atanas-n1";

  # System
  arch = "aarch64-linux";

  # Services
  services.k3s = {
    enableModule = true;
    tokenFile = ../../secrets/k3s_token;
  };
}

