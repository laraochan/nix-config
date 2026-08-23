{ inputs, username, ... }:
{
  imports = [
    ../common
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs username; };
    users.${username} = import ../../home/larao;
  };

  networking.networkmanager.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    home = "/home/${username}";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Keep this value at the version used for the first installation.
  system.stateVersion = "26.05";
}
