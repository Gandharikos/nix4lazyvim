{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.eslint;
in
{
  options.programs.lazyvim.eslint = {
    enable = mkEnableOption "linting tool - eslint";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.linting.eslint" ];
  };
}
