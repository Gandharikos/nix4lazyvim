{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.treesitter-context;
in
{
  options.programs.lazyvim.treesitter-context = {
    enable = mkEnableOption "treesitter context";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        nvim-treesitter-context
      ];

      imports = [ "lazyvim.plugins.extras.ui.treesitter-context" ];
    };
  };
}
