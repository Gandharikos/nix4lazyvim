{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.docker;
in
{
  options.programs.lazyvim.lang.docker = {
    enable = mkEnableOption "language docker";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      imports = [ "lazyvim.plugins.extras.lang.docker" ];

      extraPackages = with pkgs; [
        hadolint
      ];
    };
  };
}
