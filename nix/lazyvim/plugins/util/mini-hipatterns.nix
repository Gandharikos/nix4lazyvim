{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.util.mini-hipatterns;
in
{
  options.programs.lazyvim.util.mini-hipatterns = {
    enable = mkEnableOption "Highlight colors in your code";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        {
          name = "mini.hipatterns";
          path = mini-nvim;
        }
      ];

      imports = [ "lazyvim.plugins.extras.util.mini-hipatterns" ];
    };
  };
}
