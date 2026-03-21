{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.test;
in
{
  options.programs.lazyvim.test = {
    enable = mkEnableOption "Neotest support";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        neotest
      ];

      imports = [ "lazyvim.plugins.extras.test.core" ];
    };
  };
}
