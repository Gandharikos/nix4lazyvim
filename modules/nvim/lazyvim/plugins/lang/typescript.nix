{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.typescript;
in
{
  options.programs.lazyvim.typescript = {
    enable = mkEnableOption "language typescript";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      imports = [ "lazyvim.plugins.extras.lang.typescript" ];

      extraPackages = with pkgs; [
        typescript-language-server
        vtsls
      ];
    };
  };
}
