{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.coding.mini-surround;
in
{
  options.programs.lazyvim.coding.mini-surround = {
    enable = mkEnableOption "Fast and feature-rich surround actions";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        {
          name = "mini.surround";
          path = mini-nvim;
        }
      ];

      imports = [ "lazyvim.plugins.extras.coding.mini-surround" ];
    };
  };
}
