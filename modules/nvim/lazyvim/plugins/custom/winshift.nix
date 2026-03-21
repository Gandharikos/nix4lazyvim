{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.winshift;
in
{
  options.programs.lazyvim.winshift = {
    enable = mkEnableOption "window winshift";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [ winshift-nvim ];

      config = [ "ui/winshift.lua" ];
    };
  };
}
