{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.gx;
in
{
  options.programs.lazyvim.gx = {
    enable = mkEnableOption "gx browse";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.extraPlugins = with pkgs.vimPlugins; [
      gx-nvim
    ];

    programs.lazyvim.config = [ "misc/gx.lua" ];
  };
}
