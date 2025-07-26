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
            host_inputs = import ./hosts/${name}/inputs.nix;
          in
          # Print a message to the console during evaluation
          {
            # Use the directory name for the attribute
            name = name;
            value = nixpkgs.lib.nixosSystem {
              specialArgs = {
                inputs = host_inputs;
              };
              modules = [
                # Common modules for all hosts
                disko.nixosModules.disko
                ./generic.nix
                ./hosts/${name}/disko.nix
                ./hosts/${name}/hardware.nix
                ./hosts/${name}/configuration.nix

                ./modules/general.nix
                ./modules/roles/lab/worker.nix
              ];
            };
          };
      in
      # Build a configuration for each discovered hostname
      builtins.listToAttrs (map buildHost hostnames);
  };
}
