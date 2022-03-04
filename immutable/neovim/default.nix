{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nouunix.neovim;
  util = import ./util.nix { inherit lib; };

  pluginOptions = with types;
    submodule {
      options = {
        enable = mkOption {
          type = nullOr bool;
          default = true;
          description = "Enable the specified plugin.";
        };

        plugin = mkOption {
          type = oneOf [ package str ];
          example = "folke/which-key.nvim";
          description = ''
            The package or GitHub repository of the plugin.
          '';
        };

        as = mkOption {
          type = nullOr str;
          default = null;
          description = ''
            The alias under which to install the plugin.
          '';
        };

        run = mkOption {
          type = nullOr str;
          default = null;
          description = "Post-update/install hook.";
        };

        config = mkOption {
          type = nullOr str;
          default = null;
          description = "Lua code to run after load.";
        };

        requires = mkOption {
          type = nullOr (listOf pluginOptions);
          default = null;
          description = "Plugins dependencies.";
        };

        branch = mkOption {
          type = nullOr str;
          default = null;
          description = "The git branch to use.";
        };

        tag = mkOption {
          type = nullOr str;
          default = null;
          description = "The git tag to use.";
        };

        commit = mkOption {
          type = nullOr str;
          default = null;
          description = "The git commit to use.";
        };

        lazy = mkOption {
          type = nullOr util.lazyOptions;
          default = null;
          description = ''
            Only load plugin when it is actually needed.
          '';
        };
      };
    };
  coq = import ./completion/coq.nix { inherit config lib pkgs; };
  cmp = import ./completion/cmp.nix { inherit config lib pkgs; };

  comptionsOptions = with types;
    submodule {
      options = {
        coq = coq.options;
        cmp = cmp.options;
      };
    };
in
{
  options.nouunix.neovim = with types; {
    enable = mkEnableOption "the Neovim text editor";

    completion = mkOption {
      type = nullOr comptionsOptions;
      default = { };
      description = "Neovim autocompletion providers configuration";
    };

    plugins = mkOption {
      type = listOf (oneOf [ package pluginOptions ]);
      default = [ ];
      example = literalExpression ''[ pkgs.vimPlugins.which-key-nvim ]'';
      description = ''
        List of (Neo)Vim plugins to install.
        Some plugins can be installed and preconfigured so ensure
        that there isn't specific option for the plugin first.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users.nouun.packages = with pkgs; [ hello ];
  };
}
