{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  inherit (lib) optionals;
  cfg = config.programs.lazyvim.ai.copilot;
in
{
  options.programs.lazyvim.ai.copilot = {
    enable = mkEnableOption "AI plugin - Copilot";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      imports = [ "lazyvim.plugins.extras.ai.copilot" ];

      extraPackages = with pkgs; [ nodejs_24 ];

      extraPlugins =
        with pkgs.vimPlugins;
        [ copilot-lua ]
        ++ optionals (config.programs.lazyvim.cmp == "nvim-cmp") [ copilot-cmp ]
        ++ optionals (config.programs.lazyvim.cmp == "blink" || config.programs.lazyvim.cmp == "auto") [
          blink-cmp-copilot
        ];
    };
  };
}
