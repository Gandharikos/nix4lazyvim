{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.omnisharp;
in
{
  options.programs.lazyvim.lang.omnisharp = {
    enable = mkEnableOption "language omnisharp";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        neotest-dotnet
        omnisharp-extended-lsp-nvim
      ];

      imports = [ "lazyvim.plugins.extras.lang.omnisharp" ];

      extraPackages = with pkgs; [
        csharpier
        netcoredbg
      ];
    };
  };
}
