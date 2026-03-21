{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.luasnip;
in
{
  options.programs.lazyvim.luasnip = {
    enable = mkEnableOption "Code snippet engine - LuaSnip";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins =
        with pkgs.vimPlugins;
        [
          LuaSnip
        ]
        ++ lib.optionals (config.programs.lazyvim.cmp == "nvim-cmp") [ cmp_luasnip ];

      excludePlugins = with pkgs.VimPlugins; [
        nvim-snippets
      ];

      imports = [ "lazyvim.plugins.extras.coding.luasnip" ];
    };
  };
}
