{ inputs, pkgs, config, lib, ... }:
{
  nouunix.packages = [ (import <nixpkgs> {}).cowsay ];
  programs.neovim.enable = true;
}
