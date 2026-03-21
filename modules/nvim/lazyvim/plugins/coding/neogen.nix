{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.neogen;
in
{
  options.programs.lazyvim.neogen = {
    enable = mkEnableOption "Comment tool - mini.comment";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        neogen
      ];

      imports = [ "lazyvim.plugins.extras.coding.neogen" ];
    };
  };
}
