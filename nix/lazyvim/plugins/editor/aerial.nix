{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.editor.aerial;
in
{
  options.programs.lazyvim.editor.aerial = {
    enable = mkEnableOption "Code outline and navigation";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.editor.aerial" ];
  };
}
