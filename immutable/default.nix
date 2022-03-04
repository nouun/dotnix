{ nouunix, home, inputs, nixpkgs, ... }:
let
  config = import ../config { inherit inputs; pkgs = nixpkgs; };
in
nixpkgs.lib.nixosSystem rec {
  system = "x86_64-linux";

  modules = [
    #nouunix.nixosModules.nouunix
    home.nixosModules.home-manager
    nixpkgs.nixosModules.notDetected

    {
      #nouunix = {
      #  users.nouun = import ./nouunix.nix;
      #};

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users."${config.user.name}" = import ./home-manager;
      };

      nix = config.nix { inherit inputs system nixpkgs; };

      nixpkgs =
        let
          nixpkgs-overlays = _: _: with inputs; {
            nixpkgs-f2k = import nixpkgs-f2k { inherit config system; };
            master = import master { inherit config system; };
            unstable = import unstable { inherit config system; };
            stable = import stable { inherit config system; };
            staging = import staging { inherit config system; };
            staging-next = import staging-next { inherit config system; };
          };
        in
        {
          overlays = with inputs; [
            (self: _:
              let
                system = self.system;
              in
              (with nixpkgs-f2k.packages.${system}; {
                awesome = awesome-git;
              }))
            nixpkgs-overlays

            rust.overlay
            powercord-overlay.overlay
            neovim-nightly-overlay.overlay

            (self: super: {
              nix-direnv = super.nix-direnv.override {
                enableFlakes = true;
              };
            })
          ];
        };
    }

    ./system
  ];

  specialArgs = { inherit inputs; };
}

