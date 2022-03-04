{
  description = "L3af's personal NixOS configuration.";

  inputs = {
    nouunix = {
      url = "/home/nouun/dev/nix/nouunix";
    };
    home = {
      url = "github:l3afme/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };

    new-vim-shit.url = "github:fortuneteller2k/nixpkgs/add-vimplugins";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k?rev=29e5bf756431fa5880135fc617bb8366f6a30874";

    # powercord plugins/themes
    better-status-indicators = { url = "github:griefmodz/better-status-indicators"; flake = false; };
    channel-typing = { url = "github:powercord-community/channel-typing"; flake = false; };
    discord-tweaks = { url = "github:NurMarvin/discord-tweaks"; flake = false; };
    fix-user-popouts = { url = "github:cyyynthia/fix-user-popouts"; flake = false; };
    no-double-back-pc = { url = "github:the-cord-plug/no-double-back-pc"; flake = false; };
    powercord-popout-fix = { url = "github:Nexure/PowerCord-Popout-Fix"; flake = false; };
    rolecolor-everywhere = { url = "github:powercord-community/rolecolor-everywhere"; flake = false; };
    theme-toggler = { url = "github:redstonekasi/theme-toggler"; flake = false; };
    twemoji-but-good = { url = "github:powercord-community/twemoji-but-good"; flake = false; };
    view-raw = { url = "github:Juby210/view-raw"; flake = false; };
    who-reacted = { url = "github:jaimeadf/who-reacted"; flake = false; };
    discord-tokyonight = { url = "github:Dyzean/Tokyo-Night"; flake = false; };

    powercord-overlay.url = "github:LavaDesu/powercord-overlay";
    rust.url = "github:oxalica/rust-overlay";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    master.url = "/home/nouun/dev/nix/nixpkgs";
    stable.url = "github:nixos/nixpkgs/release-20.09";
    staging.url = "github:nixos/nixpkgs/staging";
    staging-next.url = "github:nixos/nixpkgs/staging-next";
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.follows = "master";
  };

  outputs = { self, nouunix, home, nixpkgs, ... } @ inputs:
    with nixpkgs.lib;
    {
      nixosConfigurations.nouun = import ./immutable {
        inherit nouunix home inputs nixpkgs;
      };

      nouun = self.nixosConfigurations.nouun.config.system.build.toplevel;
    };
}
