{ pkgs, conf, lib }:
{
  enable = true;

  package = pkgs.unstable.firefox.override {
    cfg = {
      enableTridactylNative = true;
    };
  };
}
