{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.erlang;
in
{
  options.programs.lazyvim.lang.erlang = {
    enable = mkEnableOption "language erlang";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.lang.erlang" ];
  };
}
