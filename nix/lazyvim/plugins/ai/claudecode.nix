{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.ai.claudecode;
in
{
  options.programs.lazyvim.ai.claudecode = {
    enable = mkEnableOption "AI plugin - Claude Code";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.ai.claudecode" ];
  };
}
