{ lib, pkgs, ... }:
# home/larao is shared by Darwin and NixOS. Ghostty is currently installed only
# on Darwin through Homebrew. Restrict this module to Darwin so that NixOS does
# not enable Ghostty's Linux-default systemd integration without a package.
lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
  programs.ghostty = {
    enable = true;

    # Ghostty itself is installed by Homebrew in modules/darwin.
    package = null;
  };
}
