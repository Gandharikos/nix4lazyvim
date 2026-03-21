{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.elm;
in
{
  options.programs.lazyvim.lang.elm = {
    enable = mkEnableOption "language elm";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.lang.elm" ];
  };
}
