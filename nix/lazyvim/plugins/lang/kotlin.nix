{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.kotlin;
in
{
  options.programs.lazyvim.lang.kotlin = {
    enable = mkEnableOption "language kotlin";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      imports = [ "lazyvim.plugins.extras.lang.kotlin" ];

      extraPackages = with pkgs; [
        kotlin-language-server
      ];
    };
  };
}
