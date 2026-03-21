{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.thrift;
in
{
  options.programs.lazyvim.lang.thrift = {
    enable = mkEnableOption "language thrift";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.lang.thrift" ];
  };
}
