{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.ui.mini-indentscope;
in
{
  options.programs.lazyvim.ui.mini-indentscope = {
    enable = mkEnableOption "Animated indent scope";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.ui.mini-indentscope" ];
  };
}
