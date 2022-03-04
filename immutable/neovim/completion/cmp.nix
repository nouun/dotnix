{ config, lib, pkgs, ... }:
with lib;
let
  util = import ../util.nix { inherit lib; };

  keymap = with types; submodule {
    options = {
      useDefault = mkOption {
        type = bool;
        default = true;
        description = ''
          Use the default keybinds provided cmp suggests.
        '';
      };

      useWhichKey = mkOption {
        type = bool;
        default = false;
        description = ''
          Recreate the default binds using WhichKey.nvim.
          This will requires and will install WhichKey.nvim
          if it's not already installed.
        '';
      };
    };
  };

  cmpOptions = with types; submodule {
    options = {
      enable = mkEnableOption "cmp completions";

      lazy = mkOption {
        type = nullOr util.lazyOptions;
        default = null;
        description = "Lazy load cmp.";
      };

      sources = mkOption {
        type = listOf str;
        default = [ "buffer" ];
        description = "Completion sources.";
      };

      menuItems = mkOption {
        type = nullOr attrs;
        default = {
          path = "path";
          buffer = "buff";
          nvim_lsp = "lsp";
        };
        description = "Menu item names.";
      };

      keymap = mkOption {
        type = nullOr keymap;
        default = { };
        description = "Keymap options.";
      };

      extraConfig = mkOption {
        type = nullOr str;
        default = null;
        example = literalExpression ''
        \'\'
          vim.g.display.pum.fast_close = false;
          vim.g.display.icons.mode = "none";
        \'\'
          '';
        description = ''
          Extra lua config which will only be used if cmp is enabled.
        '';
      };
    };
  };
in
rec {
  options = mkOption {
    type = types.nullOr cmpOptions;
    default = { };
    description = ''
      A completion plugin for neovim coded in Lua.
      [Link](https://github.com/hrsh7th/nvim-cmp)
    '';
  };
}
