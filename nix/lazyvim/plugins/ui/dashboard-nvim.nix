{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.ui.dashboard-nvim;
in
{
  options.programs.lazyvim.ui.dashboard-nvim = {
    enable = mkEnableOption "Dashboard-nvim greeter";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.ui.dashboard-nvim" ];
  };
}
