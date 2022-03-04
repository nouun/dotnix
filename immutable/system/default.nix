{ inputs, pkgs, lib, ... }:
let
  config = import ../../config { inherit inputs pkgs; };
  termBase16 = map (builtins.replaceStrings [ "#" ] [ "" ])
    config.theme.ttyBase16;

  getBin = config.helpers.getBin;
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "${config.user.name}-nixos";

    useDHCP = false;
    interfaces = {
      enp1s0f0.useDHCP = true;
      wlp2s0.useDHCP = true;
    };

    firewall =
      let
        openPorts = [ 8080 8000 ];
      in
      {
        allowedTCPPorts = openPorts;
        allowedUDPPorts = openPorts;
      };

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];

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
        "Ryan's iPhone" = {
          pskRaw = "f18220829f66a4df65e2f4f256d3458e9d36233e58f030401beb1cce8c8e9000";
        };
        "SPARK-2CZ8ZA" = {
          pskRaw = "f113adb00c2b8ffee0d163225037df2b7fb39fa9011f3864125822ee0b55cf74";
        };
      };
    };
  };

  i18n = {
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
    inputMethod.enabled = "kime";
  };
  console = {
    colors = termBase16;
    font = "Lat2-Terminus16";
    earlySetup = true;
    useXkbConfig = true;
  };

  powerManagement.cpuFreqGovernor = "performance";

  programs = {
    xwayland.enable = true;
    command-not-found.enable = false;
  };

  services = {
    xserver =
      with config.user.xserver;
    {
      enable = enable;
      dpi = 96;

      layout = "semimak";
      xkbOptions = "caps:escape";

      extraLayouts = {
        semimak = {
          description = "Semimak";
          languages = [ "eng" ];
          symbolsFile = ./layouts/semimak;
        };
      };

      libinput = {
        enable = true;

        touchpad = {
          tapping = true;
          naturalScrolling = true;
        };
      };

      videoDrivers = [ "displaylink" "modesetting" ];

      displayManager = {
        startx.enable = true;
# defaultSession = "none+${defaultSession}";

        lightdm.greeters.gtk = {
          enable = true;

          extraConfig = ''
            position = 10%,start 65%,center
            default-user-image = /assets/usericon
            xft-antialias = true
            xft-dpi = 96
            xft-hintstyle = slight
            xft-rgba = rgb
            indicators = ~clock;~power;
          '';
        };
      };
    };

#touchegg.enable = true;
    openssh.enable = true;

    udev = {
      extraRules = ''
        SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", SYMLINK+="android_adb", MODE="0666", GROUP="plugdev"
      '';
    };

    postgresql = {
      enable = true;
      package = pkgs.postgresql_10;

      enableTCPIP = true;

      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all all trust
        '';

      initialScript = pkgs.writeText "backend-initScript" ''
        CREATE ROLE tradeswarm WITH LOGIN PASSWORD 'tradeswarm' CREATEDB;
        CREATE DATABASE tradeswarm;
        GRANT ALL PRIVILEGES ON DATABASE tradeswarm TO tradeswarm;
      '';
    };
  };

  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;

    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  users = {
    mutableUsers = false;

    users."${config.user.name}" = {
      isNormalUser = true;
      hashedPassword = config.user.password;
      home = config.user.homeDir;
      extraGroups = [
        "adbusers"
        "audio"
        "video"
        "wheel"
        "tty"
        "dialout"
        "plugdev"
      ];
    };
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg: builtins.elem (lib.getName pkg)
      ([
        "broadcom-sta"
        "discord-canary"
      ] ++ config.user.unfreePredicate);

  environment = {
    binsh = "${pkgs.dash}/bin/dash";

    pathsToLink = [
      "/share/nix-direnv"
    ];

    systemPackages = with pkgs; [
      curl
      dash
      file
      gcc
      ripgrep
      unzip
      zip

      lua5_4

      direnv
      nix-direnv
    ] ++ config.user.systemPackages;
  };

  fonts = {
    fonts = with pkgs; [
      fira-code
      fira-code-symbols
      (nerdfonts.override {
        fonts = [
          "FiraCode"
        ];
      })
      twemoji-color-font
      nanum-gothic-coding
    ];

    fontconfig.enable = true;
  };

  system.userActivationScripts = {
    batRebuildCache = {
      text = ''
        ${getBin pkgs.bat} cache --build
      '';
      deps = [ ];
    };
  };

  security.pki.certificateFiles = [ "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" ];

  system.stateVersion = "21.05";
}
