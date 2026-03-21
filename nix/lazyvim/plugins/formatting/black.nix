{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.formatting.black;
in
{
  options.programs.lazyvim.formatting.black = {
    enable = mkEnableOption "formatting tool - black";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      imports = [ "lazyvim.plugins.extras.formatting.black" ];

      extraPackages = with pkgs; [
        black
      ];
    };
  };
}
