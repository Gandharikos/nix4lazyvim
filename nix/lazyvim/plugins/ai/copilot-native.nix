{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.ai.copilot-native;
in
{
  options.programs.lazyvim.ai.copilot-native = {
    enable = mkEnableOption "AI plugin - Copilot native LSP";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      imports = [ "lazyvim.plugins.extras.ai.copilot-native" ];

      extraPackages = with pkgs; [
        nodejs_24
        copilot-language-server
      ];
    };
  };
}
