{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.toml;
in
{
  options.programs.lazyvim.lang.toml = {
    enable = mkEnableOption "language toml";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      imports = [ "lazyvim.plugins.extras.lang.toml" ];

      extraPackages = with pkgs; [
        taplo
      ];
    };
  };
}
