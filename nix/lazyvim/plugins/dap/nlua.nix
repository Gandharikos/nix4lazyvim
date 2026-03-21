{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.dap.nlua;
in
{
  options.programs.lazyvim.dap.nlua = {
    enable = mkEnableOption "DAP for Neovim Lua";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.dap.nlua" ];
  };
}
