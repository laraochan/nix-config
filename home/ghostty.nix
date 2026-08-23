{ ... }:
{
  programs.ghostty = {
    enable = true;

    # Installed by Homebrew on Darwin and by modules/nixos on NixOS.
    package = null;
    systemd.enable = false;

    settings = {
      font-family = "JetBrainsMono Nerd Font";
      theme = "TokyoNight";
      macos-option-as-alt = true;
      shell-integration-features = "no-cursor";
      cursor-style = "bar";
      unfocused-split-opacity = 0.7;
      unfocused-split-fill = "000000";
    };
  };
}
