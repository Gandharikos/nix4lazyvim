{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.solidity;
in
{
  options.programs.lazyvim.lang.solidity = {
    enable = mkEnableOption "language solidity";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.lang.solidity" ];
  };
}
