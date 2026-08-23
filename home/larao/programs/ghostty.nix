{ ... }:
{
  programs.ghostty = {
    enable = true;

    # Installed by Homebrew on Darwin and by modules/nixos on NixOS.
    package = null;
    systemd.enable = false;
  };
}
