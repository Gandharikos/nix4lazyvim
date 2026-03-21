{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.ui.indent-blankline;
in
{
  options.programs.lazyvim.ui.indent-blankline = {
    enable = mkEnableOption "Indent guides";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.ui.indent-blankline" ];
  };
}
