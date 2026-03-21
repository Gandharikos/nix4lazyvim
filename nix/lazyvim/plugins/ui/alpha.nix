{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.ui.alpha;
in
{
  options.programs.lazyvim.ui.alpha = {
    enable = mkEnableOption "Alpha greeter dashboard";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.ui.alpha" ];
  };
}
