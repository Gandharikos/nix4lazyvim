{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.util.gitui;
in
{
  options.programs.lazyvim.util.gitui = {
    enable = mkEnableOption "GitUI terminal UI";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.util.gitui" ];
  };
}
