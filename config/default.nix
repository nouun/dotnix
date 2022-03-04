###################
#  DO NOT MODIFY  #
###################

{ inputs, pkgs, ... }:
rec {
  programs = import ./programs { inherit inputs pkgs; };
  theme = import ./theme.nix { inherit pkgs; };
  user = import ./config.nix { inherit inputs pkgs; };

  helpers = import ./helpers.nix { lib = pkgs.lib; };

  nix = import ./nix-config.nix;
}
