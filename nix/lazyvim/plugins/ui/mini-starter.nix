{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.ui.mini-starter;
in
{
  options.programs.lazyvim.ui.mini-starter = {
    enable = mkEnableOption "Mini starter screen";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.ui.mini-starter" ];
  };
}
