{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim;
in
{
  config = mkIf (cfg.cmp == "auto" || cfg.cmp == "blink") {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        blink-cmp
        blink-compat
        friendly-snippets
      ];

      excludePlugins = with pkgs.vimPlugins; [
        nvim-cmp
      ];
    };
  };
}
