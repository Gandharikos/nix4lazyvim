{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.inc-rename;
in
{
  options.programs.lazyvim.inc-rename = {
    enable = mkEnableOption "Incremental LSP renaming based on Neovim's command-preview feature";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        inc-rename-nvim
      ];

      imports = [ "lazyvim.plugins.extras.editor.inc-rename" ];
    };
  };
}
