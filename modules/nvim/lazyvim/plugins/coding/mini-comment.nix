{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.mini-comment;
in
{
  options.programs.lazyvim.mini-comment = {
    enable = mkEnableOption "Comment tool - mini.comment";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        {
          name = "mini.comment";
          path = mini-nvim;
        }
        nvim-ts-context-commentstring
      ];

      imports = [ "lazyvim.plugins.extras.coding.mini-comment" ];
    };
  };
}
