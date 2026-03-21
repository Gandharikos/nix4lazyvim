{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.ai.codeium;
in
{
  options.programs.lazyvim.ai.codeium = {
    enable = mkEnableOption "AI plugin - Codeium";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.ai.codeium" ];
  };
}
