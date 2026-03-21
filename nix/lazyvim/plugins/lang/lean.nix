{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.lean;
in
{
  options.programs.lazyvim.lang.lean = {
    enable = mkEnableOption "language lean";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        lean-nvim
      ];
      imports = [ "lazyvim.plugins.extras.lang.lean" ];
      extraPackages = with pkgs; [
        lean4
      ];
    };
  };
}
