{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.mini-diff;
in
{
  options.programs.lazyvim.mini-diff = {
    enable = mkEnableOption "Mini diff signs";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        {
          name = "mini.diff";
          path = mini-nvim;
        }
      ];

      imports = [ "lazyvim.plugins.extras.editor.mini-diff" ];
    };
  };
}
