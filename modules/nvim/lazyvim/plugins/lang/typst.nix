{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.typst;
in
{
  options.programs.lazyvim.typst = {
    enable = mkEnableOption "language typst";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      imports = [ "lazyvim.plugins.extras.lang.typst" ];

      extraPlugins = with pkgs.vimPlugins; [
        typst-preview-nvim
      ];
    };
  };
}
