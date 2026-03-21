{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.python;
in
{
  options.programs.lazyvim.python = {
    enable = mkEnableOption "language python";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        neotest-python
        nvim-dap-python
        venv-selector-nvim
      ];

      imports = [ "lazyvim.plugins.extras.lang.python" ];

      extraPackages = with pkgs; [
        pyright
        ruff
        basedpyright
      ];
    };
  };
}
