{
  description = "Homelab NixOS Flake";

  inputs = {
    #NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    #Home Manager for user-level package management
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disko for hard disk configuartions
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, disko, ... }@inputs: {
    nixosConfigurations =
      let
        # Find all directories in ./hosts, each representing a machine
        hostnames = builtins.attrNames (builtins.readDir ./hosts);

        # Function to build a single host configuration
        buildHost = name:
          let
            # Import the host-specific attributes
            node = import ./hosts/${name}/host.nix;
          in
          # Print a message to the console during evaluation
          {
            # Use the directory name for the attribute
            name = name;
            value = nixpkgs.lib.nixosSystem {
              system = node.arch;
              specialArgs = {
                meta = {
                  node = node;
                };
              };
              modules = [
                # Common modules for all hosts
                disko.nixosModules.disko
                ./modules/k3s.nix
                ./hosts/${name}/disko.nix
                ./config.nix

                # The new, dynamic hardware configuration
                ./hosts/${name}/hardware.nix
              ];
            };
          };
      in
      # Build a configuration for each discovered hostname
      builtins.listToAttrs (map buildHost hostnames);
  };
}
