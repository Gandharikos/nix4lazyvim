{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.zig;
in
{
  options.programs.lazyvim.zig = {
    enable = mkEnableOption "language zig";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        neotest-zig
      ];

      imports = [ "lazyvim.plugins.extras.lang.zig" ];

      extraPackages = with pkgs; [
        zls
      ];
    };
  };
}
