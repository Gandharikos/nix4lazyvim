{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.tailwind;
in
{
  options.programs.lazyvim.tailwind = {
    enable = mkEnableOption "language tailwind";
  };

  config = mkIf cfg.enable {
    /*
         programs.lazyvim.extraPlugins = with pkgs.vimPlugins; [
        tailwindcss-colorizer-cmp-nvim
      ];
    */
    programs.lazyvim = {
      imports = [ "lazyvim.plugins.extras.lang.tailwind" ];

      extraPackages = with pkgs; [
        tailwindcss
      ];
    };
  };
}
