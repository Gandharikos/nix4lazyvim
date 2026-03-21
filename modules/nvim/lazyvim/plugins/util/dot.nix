{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.dot;
in
{
  options.programs.lazyvim.dot = {
    enable = mkEnableOption "Language support for dotfiles";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      imports = [ "lazyvim.plugins.extras.util.dot" ];

      extraPackages = with pkgs; [
        shellcheck
      ];
    };
  };
}
