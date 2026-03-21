{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lsp.neoconf;
in
{
  options.programs.lazyvim.lsp.neoconf = {
    enable = mkEnableOption "Neovim config file support";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.lsp.neoconf" ];
  };
}
