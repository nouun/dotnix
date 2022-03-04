{ inputs, pkgs }:
rec {
  git = import ./git.nix { inherit inputs pkgs; };
  kitty = import ./kitty.nix;
  neovim = import ./neovim.nix { inherit inputs pkgs; };
  vieb = import ./vieb.nix { inherit inputs pkgs; };
}
