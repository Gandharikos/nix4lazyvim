{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.harpoon;
in
{
  options.programs.lazyvim.harpoon = {
    enable = mkEnableOption "harpoon2";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        harpoon
      ];

      imports = [ "lazyvim.plugins.extras.editor.harpoon2" ];
    };
  };
}
