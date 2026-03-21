{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.clojure;
in
{
  options.programs.lazyvim.clojure = {
    enable = mkEnableOption "language clojure";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins =
        with pkgs.vimPlugins;
        [
          nvim-treesitter-sexp
          baleia-nvim
          conjure
        ]
        ++ lib.optionals (config.programs.lazyvim.cmp == "nvim-cmp") [ cmp-conjure ];

      imports = [ "lazyvim.plugins.extras.lang.clojure" ];

      extraPackages = with pkgs; [
        astro-language-server
      ];
    };
  };
}
