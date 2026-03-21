{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.editor.snacks-explorer;
in
{
  options.programs.lazyvim.editor.snacks-explorer = {
    enable = mkEnableOption "Snacks explorer";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.editor.snacks_explorer" ];
  };
}
