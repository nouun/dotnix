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
          Use the default keybinds provided by coq itself.
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

  autostart = with types; submodule {
    options = {
      enable = mkOption {
        type = nullOr bool;
        default = true;
        description = "Autostart coq.";
      };

      quiet = mkOption {
        type = nullOr bool;
        default = true;
        description = "Disable startup message when coq is available.";
      };

    };
  };

  coqOptions = with types; submodule {
    options = {
      enable = mkEnableOption "coq completions";

      lazy = mkOption {
        type = nullOr util.lazyOptions;
        default = null;
        description = "Lazy load coq.";
      };

      autostart = mkOption {
        type = nullOr autostart;
        default = { };
        description = "Autostart options.";
      };

      keymap = mkOption {
        type = nullOr keymap;
        default = { };
        description = "Keymap options.";
      };

      sources = mkOption {
        type = nullOr attrs;
        default = null;
        example = literalExpression ''
          {
            tabnine.enable = true;

            paths.preview_lines = 6;

            tree_sitter = {
              seach_context = 333;
              slow_threshold = 0.1;
            };
          }
        '';
        description = ''
          Configuration for coq sources.
          See [here](https://github.com/ms-jpq/coq_nvim/blob/coq/docs/SOURCES.md) for available options.
        '';
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
          Extra lua config which will only be used if coq is enabled.
        '';
      };
    };
  };
in
rec {
  options = mkOption {
    type = types.nullOr coqOptions;
    default = { };
    description = ''
      Fast as FUCK nvim completion.
      [Link](https://github.com/ms-jpq/coq_nvim)
    '';
  };
}
