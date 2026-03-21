{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.editor.navic;
in
{
  options.programs.lazyvim.editor.navic = {
    enable = mkEnableOption "LSP breadcrumb navigation";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.editor.navic" ];
  };
}
