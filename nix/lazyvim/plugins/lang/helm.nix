{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.helm;
in
{
  options.programs.lazyvim.lang.helm = {
    enable = mkEnableOption "language helm";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      imports = [ "lazyvim.plugins.extras.lang.helm" ];

      extraPackages = with pkgs; [
        kubernetes-helm
        helm-ls
      ];
    };
  };
}
