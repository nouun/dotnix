{ config, lib, pkgs, ... }:
with lib;
let
  config = config.modules.neovim.completion.coq;

in
rec {
  options = types.submodule {
    options = {
      
    };
  };

  createConfig = config: {
  };
}
