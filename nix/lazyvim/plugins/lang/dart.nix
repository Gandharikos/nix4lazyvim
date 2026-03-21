{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.dart;
in
{
  options.programs.lazyvim.lang.dart = {
    enable = mkEnableOption "language dart";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      imports = [ "lazyvim.plugins.extras.lang.dart" ];

      extraPackages = with pkgs; [
        dart
      ];
    };
  };
}
