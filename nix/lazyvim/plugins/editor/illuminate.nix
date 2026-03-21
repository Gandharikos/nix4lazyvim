{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.editor.illuminate;
in
{
  options.programs.lazyvim.editor.illuminate = {
    enable = mkEnableOption "Highlight word occurrences";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.editor.illuminate" ];
  };
}
