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
  config = mkIf (cfg.cmp == "nvim-cmp") {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        nvim-snippets
        friendly-snippets
        # my custom nvim plugins
        cmp-cmdline
        cmp-emoji
        cmp-nvim-lua
        cmp-cmdline-history
        cmp-nvim-lsp
      ];

      excludePlugins = with pkgs.vimPlugins; [
        blink-cmp
        blink-compat
      ];

      config = [ "coding/nvim-cmp.lua" ];
    };
  };
}
