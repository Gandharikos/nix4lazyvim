{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.prisma;
in
{
  options.programs.lazyvim.lang.prisma = {
    enable = mkEnableOption "language prisma";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.lang.prisma" ];
  };
}
