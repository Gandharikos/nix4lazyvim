{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.angular;
in
{
  options.programs.lazyvim.angular = {
    enable = mkEnableOption "language angular";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      typescript.enable = true;

      imports = [ "lazyvim.plugins.extras.lang.angular" ];

      extraPackages = with pkgs; [
        angular-language-server
      ];
    };
  };
}
