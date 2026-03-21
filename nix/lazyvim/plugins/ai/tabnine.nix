{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.ai.tabnine;
in
{
  options.programs.lazyvim.ai.tabnine = {
    enable = mkEnableOption "AI plugin - tabnine";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        cmp-tabnine
      ];

      imports = [ "lazyvim.plugins.extras.ai.tabnine" ];
    };
  };
}
