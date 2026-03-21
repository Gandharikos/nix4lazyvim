{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.yanky;
in
{
  options.programs.lazyvim.yanky = {
    enable = mkEnableOption "better yank/paste";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        yanky-nvim
      ];

      imports = [ "lazyvim.plugins.extras.coding.yanky" ];
    };
  };
}
