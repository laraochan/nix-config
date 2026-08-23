{ ... }:
{
  imports = [ ../../../modules ];

  networking.hostName = "laraos-MacBook-Pro";
  nixpkgs.hostPlatform = "aarch64-darwin";
}
