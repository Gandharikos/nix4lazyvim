{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.ai.avante;
in
{
  options.programs.lazyvim.ai.avante = {
    enable = mkEnableOption "AI plugin - avante";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.ai.avante" ];
  };
}
