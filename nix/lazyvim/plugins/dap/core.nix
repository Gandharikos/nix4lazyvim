{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.dap.core;
in
{
  options.programs.lazyvim.dap.core = {
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

      imports = [ "lazyvim.plugins.extras.dap.core" ];
    };
  };
}
