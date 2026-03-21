{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.vue;
in
{
  options.programs.lazyvim.vue = {
    enable = mkEnableOption "language vue";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      typescript.enable = true;

      imports = [ "lazyvim.plugins.extras.lang.vue" ];

      extraPackages = with pkgs; [
        vscode-extensions.vue.volar
        vtsls
      ];
    };
  };
}
