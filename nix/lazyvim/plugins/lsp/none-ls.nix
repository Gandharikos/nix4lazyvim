{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lsp.none-ls;
in
{
  options.programs.lazyvim.lsp.none-ls = {
    enable = mkEnableOption "None-ls (null-ls) LSP integration";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.lsp.none-ls" ];
  };
}
