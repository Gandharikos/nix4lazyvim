{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.ai.sidekick;
in
{
  options.programs.lazyvim.ai.sidekick = {
    enable = mkEnableOption "AI plugin - sidekick";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        sidekick-nvim
      ];

      imports = [ "lazyvim.plugins.extras.ai.sidekick" ];
    };
  };
}
