{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.editor.snacks-picker;
in
{
  options.programs.lazyvim.editor.snacks-picker = {
    enable = mkEnableOption "Snacks picker";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.editor.snacks_picker" ];
  };
}
