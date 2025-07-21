{
  description = "Homelab NixOS Flake";

  inputs = {
    #NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    #Home Manager for user-level package management
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disko for hard disk configuartions
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, disko, ... }@inputs: {
    nixosConfigurations = 
      let
        # Find all .nix files in ./hosts, each representing a machine
        hostFiles = builtins.filter (file: builtins.match ".*\\.nix" file != null) (builtins.attrNames (builtins.readDir ./hosts));

        # Function to build a single host configuration
        buildHost = file:
          let 
            hostConfig = import ./hosts/${file};
          in
          # Print a message to the console during evaluation
          {
            # Use the stripped name for the attribute
            name = hostConfig.hostname;
            value = nixpkgs.lib.nixosSystem {
              system = hostConfig.arch;
              specialArgs = {
                meta = {
                  node = hostConfig;
                };
              };
              modules = [
                # Common modules for all hosts
                disko.nixosModules.disko
                ./disko.nix
                ./config.nix

                # The new, dynamic hardware configuration
                ./hardware.nix
              ];
            };
          };
      in
      # Build a configuration for each discovered hostname
      builtins.listToAttrs (map buildHost hostFiles);
  };
}
