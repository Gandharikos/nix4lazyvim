{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.black;
in
{
  options.programs.lazyvim.black = {
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
