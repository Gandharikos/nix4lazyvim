{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.util.gh;
in
{
  options.programs.lazyvim.util.gh = {
    enable = mkEnableOption "GitHub CLI integration";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.util.gh" ];
  };
}
