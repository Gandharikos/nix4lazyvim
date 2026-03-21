{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.quarto;
in
{
  options.programs.lazyvim.quarto = {
    enable = mkEnableOption "language quarto";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        quarto-nvim
        otter-nvim
        vim-slime
        jupytext-nvim
        img-clip-nvim
      ];

      config = [ "lang/quarto.lua" ];
    };
  };
}
