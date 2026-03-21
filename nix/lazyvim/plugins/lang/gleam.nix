{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.gleam;
in
{
  options.programs.lazyvim.lang.gleam = {
    enable = mkEnableOption "language gleam";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.lang.gleam" ];
  };
}
