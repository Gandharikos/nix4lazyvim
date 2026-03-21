{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.tex;
in
{
  options.programs.lazyvim.tex = {
    enable = mkEnableOption "language tex";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        vimtex
      ];

      imports = [ "lazyvim.plugins.extras.lang.tex" ];
    };
  };
}
