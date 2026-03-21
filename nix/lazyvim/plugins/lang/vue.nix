{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.vue;
in
{
  options.programs.lazyvim.lang.vue = {
    enable = mkEnableOption "language vue";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      lang.typescript.enable = true;

      imports = [ "lazyvim.plugins.extras.lang.vue" ];

      extraPackages = with pkgs; [
        vscode-extensions.vue.volar
        vtsls
      ];
    };
  };
}
