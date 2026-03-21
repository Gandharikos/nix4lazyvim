{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.go;
in
{
  options.programs.lazyvim.go = {
    enable = mkEnableOption "language go";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        nvim-dap-go
        neotest-golang
      ];

      imports = [ "lazyvim.plugins.extras.lang.go" ];

      extraPackages = with pkgs; [
        delve
        gopls
        gotools
        gofumpt
        gomodifytags
        impl
      ];
    };
  };
}
