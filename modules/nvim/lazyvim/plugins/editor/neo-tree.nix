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
  config = mkIf (cfg.explorer == "neo-tree") {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        neo-tree
      ];

      config = [ "editor/neo-tree.lua" ];
    };
  };
}
