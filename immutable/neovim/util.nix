{ lib }:
let
  mkLazyOption = with lib; with types;
    name: ending: example:
      mkOption {
        type = oneOf [ (listOf str) str ];
        example = example;
        description = ''
          List of ${name}s to load the plugin when ${ending}.
        '';
      };
in
rec {
  lazyOptions = with lib; with types;
    submodule {
      options = {
        event = mkLazyOption "event" "called" "BufReadPre";
        ft = mkLazyOption "filetype" "opened" (literalExpression ''[ "clojure" "fennel" ]'');
        cmd = mkLazyOption "command" "run" "Commentary";
        keys = mkLazyOption "key" "pressed" "<Leader>a";
        fn = mkLazyOption "function" "called" "Telescope";
        module = mkLazyOption "lua module" "required" "Telescope";
      };
    };
}
