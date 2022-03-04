{ inputs, config, pkgs, lib, ... }:
let
  conf = (import ../../../../config { inherit inputs pkgs; });
in
{
  config = lib.mkIf (conf.user.firefox.enable) {
    programs.firefox = import ./config.nix   { inherit pkgs conf lib; };
    xdg.configFile   = import ./external.nix { inherit pkgs conf lib; }; 
  };
}
