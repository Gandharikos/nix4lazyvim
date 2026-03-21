{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.java;
in
{
  options.programs.lazyvim.java = {
    enable = mkEnableOption "language java";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        nvim-jdtls
      ];

      imports = [ "lazyvim.plugins.extras.lang.java" ];

      extraPackages = with pkgs; [
        vscode-extensions.vscjava.vscode-java-debug
        vscode-extensions.vscjava.vscode-java-test
      ];
    };
  };
}
