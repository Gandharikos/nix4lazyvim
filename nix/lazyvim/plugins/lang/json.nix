{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.json;
in
{
  options.programs.lazyvim.lang.json = {
    enable = mkEnableOption "language json";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        SchemaStore-nvim
        crates-nvim
      ];

      imports = [ "lazyvim.plugins.extras.lang.json" ];

      extraPackages = with pkgs; [
        bacon
        rust-analyzer
        vscode-extensions.vadimcn.vscode-lldb
      ];
    };
  };
}
