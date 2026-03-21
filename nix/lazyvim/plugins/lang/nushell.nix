{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.nushell;
in
{
  options.programs.lazyvim.lang.nushell = {
    enable = mkEnableOption "language nushell";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.lang.nushell" ];
  };
}
