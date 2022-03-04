#
#     ██████╗ ██╗████████╗
#    ██╔════╝ ██║╚══██╔══╝
#    ██║  ███╗██║   ██║
#    ██║   ██║██║   ██║
#    ╚██████╔╝██║   ██║
#     ╚═════╝ ╚═╝   ╚═╝
#  https://github.com/git/git

{ inputs, pkgs }:
let
  user = (import ../config.nix { inherit inputs pkgs; });
in
rec {
  configOptions = {
    user = {
      name = "nouun";
      email = user.email;
    };

    defaultBranch = "master";

    otherConfig = {
      url."ssh://git@host".insteadOf = "otherHost";
    };
  };
}
