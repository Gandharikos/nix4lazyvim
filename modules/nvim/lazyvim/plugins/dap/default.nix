{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.dap;
in
{
  options.programs.lazyvim.dap = {
    enable = mkEnableOption "Debugging support";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        nvim-dap
        nvim-dap-ui
        nvim-dap-virtual-text
        nvim-nio
        one-small-step-for-vimkind
      ];

      # disable mason-nvim-dap.nvim
      extraSpec = ''
        { "jay-babu/mason-nvim-dap.nvim", enabled = false },
      '';

      config = [ "editor/dap.lua" ];
    };
  };
}
