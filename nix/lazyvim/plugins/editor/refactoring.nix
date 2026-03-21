{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.editor.refactoring;
in
{
  options.programs.lazyvim.editor.refactoring = {
    enable = mkEnableOption "Refactoring tool";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        refactoring-nvim
      ];

      imports = [ "lazyvim.plugins.extras.editor.refactoring" ];
    };
  };
}
