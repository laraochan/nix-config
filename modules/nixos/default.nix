{
  inputs,
  lib,
  pkgs,
  systemPlatform,
  username,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = {
      inherit inputs username;
      homePlatform = systemPlatform;
    };
    users.${username} = import ../../home;
  };

  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "1password"
      "1password-cli"
      "obsidian"
      "spotify"
    ];

  time.timeZone = "Asia/Tokyo";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "ja_JP.UTF-8";
      LC_IDENTIFICATION = "ja_JP.UTF-8";
      LC_MEASUREMENT = "ja_JP.UTF-8";
      LC_MONETARY = "ja_JP.UTF-8";
      LC_NAME = "ja_JP.UTF-8";
      LC_NUMERIC = "ja_JP.UTF-8";
      LC_PAPER = "ja_JP.UTF-8";
      LC_TELEPHONE = "ja_JP.UTF-8";
      LC_TIME = "ja_JP.UTF-8";
    };
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-gtk
          fcitx5-mozc
        ];
        ignoreUserConfig = true;
        settings.inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "keyboard-us";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "mozc";
        };
      };
    };
  };

  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    logind.settings.Login.HandleLidSwitch = "ignore";
    printing.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  security.rtkit.enable = true;

  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ username ];
    };
    dconf.enable = true;
    firefox.enable = true;
  };

  environment.systemPackages = with pkgs; [
    ghostty
    obsidian
    spotify
    vesktop

    gnomeExtensions.appindicator
    gnomeExtensions.kimpanel
  ];

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    home = "/home/${username}";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Keep this value at the version used for the first installation.
  system.stateVersion = "26.05";
}
