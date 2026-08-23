{ ... }:
{
  imports = [ ../../../modules/darwin ];

  networking.hostName = "laraos-MacBook-Pro";
  nixpkgs.hostPlatform = "aarch64-darwin";
}
