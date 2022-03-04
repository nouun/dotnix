# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "nouun-nixos";
    useDHCP = false;

    interfaces = {
      enp1s0f0.useDHCP = true;
      wlp2s0.useDHCP = true;
    };

    wireless = {
      enable = true;
      userControlled.enable = true;

      interfaces = [
        "wlp2s0"
      ];

      networks = {
        uberB07D = {
          pskRaw = "6628b832dcf6f2712d56b6986271f914131a51293d36fae560cf41061b75bfad";
        };
      };
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services = {
    xserver = {
      enable = true;

      layout = "us";
      xkbVariant = "dvorak";
      xkbOptions = "caps:escape";

      libinput.enable = true;
    };
    
    openssh.enable = true;
  };

  users = {
    mutableUsers = false;

    users.nouun = {
      isNormalUser = true;
      hashedPassword = "$6$KaIMxFpIUCWjkkSF$y7G9/JdFgGAfTewFQdDX43cd2sr3IxO7Ze0rjx8InFFGO07YdXWVG9W6/jRh5s7Xx5rJoblJO3w5ic2ajRn4D/";
      extraGroups = [ "wheel" ];
    };
  };
  
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";
  };
  
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ([
    "broadcom-sta"
  ] ++ config.user.unfree);

  environment.systemPackages = with pkgs; [
    git
    vim
    firefox
  ];

  system.stateVersion = "21.05";
}

