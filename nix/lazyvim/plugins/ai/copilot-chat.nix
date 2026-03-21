{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.ai.copilot-chat;
in
{
  options.programs.lazyvim.ai.copilot-chat = {
    enable = mkEnableOption "AI plugin - Copilot Chat";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      imports = [ "lazyvim.plugins.extras.ai.copilot-chat" ];

      extraPackages = with pkgs; [ nodejs_24 ];

      extraPlugins = with pkgs.vimPlugins; [ CopilotChat-nvim ];
    };
  };
}
