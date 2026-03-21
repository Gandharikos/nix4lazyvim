{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.vscode;
in
{
  options.programs.lazyvim.vscode = {
    enable = mkEnableOption "LazyVim integration with Visual Studio Code";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.vscode" ];
  };
}
