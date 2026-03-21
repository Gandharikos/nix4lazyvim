{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.formatting.prettier;
in
{
  options.programs.lazyvim.formatting.prettier = {
    enable = mkEnableOption "formatting tool - prettier";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPackages = with pkgs; [
        nodePackages.prettier
      ];

      imports = [ "lazyvim.plugins.extras.formatting.prettier" ];
    };
  };
}
