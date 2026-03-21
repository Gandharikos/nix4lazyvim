{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.editor.leap;
in
{
  options.programs.lazyvim.editor.leap = {
    enable = mkEnableOption "Fast cursor navigation";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.editor.leap" ];
  };
}
