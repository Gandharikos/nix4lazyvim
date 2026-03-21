{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.cmake;
in
{
  options.programs.lazyvim.cmake = {
    enable = mkEnableOption "language cmake";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      excludePlugins = with pkgs.vimPlugins; [
        cmake-tools-nvim
      ];

      extraPlugins = with pkgs.vimPlugins; [
        cmake-tools-nvim
      ];

      imports = [ "lazyvim.plugins.extras.lang.cmake" ];

      extraPackages = with pkgs; [
        cmake-language-server
        cmake-lint
        neocmakelsp
      ];
    };
  };
}
