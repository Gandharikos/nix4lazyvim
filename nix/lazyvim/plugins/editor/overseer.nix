{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.editor.overseer;
in
{
  options.programs.lazyvim.editor.overseer = {
    enable = mkEnableOption "overseer";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        overseer-nvim
      ];

      imports = [ "lazyvim.plugins.extras.editor.overseer" ];
    };
  };
}
