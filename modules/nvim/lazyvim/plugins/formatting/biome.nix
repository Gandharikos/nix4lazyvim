{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.biome;
in
{
  options.programs.lazyvim.biome = {
    enable = mkEnableOption "formatting tool - biome";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      imports = [ "lazyvim.plugins.extras.formatting.biome" ];

      extraPackages = with pkgs; [
        biome
      ];
    };
  };
}
