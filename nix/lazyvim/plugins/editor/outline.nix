{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.editor.outline;
in
{
  options.programs.lazyvim.editor.outline = {
    enable = mkEnableOption "Code outline sidebar";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.editor.outline" ];
  };
}
