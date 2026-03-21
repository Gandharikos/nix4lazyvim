{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.r;
  inherit (lib.meta) getExe;
  R' = getExe pkgs.R;
  r-language-server = pkgs.writeShellScriptBin "r-language-server" ''
    exec ${R'} --slave -e 'languageserver::run()'
  '';
in
{
  options.programs.lazyvim.r = {
    enable = mkEnableOption "language r";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        R-nvim
        # cmp-r
        neotest-testthat
      ];

      imports = [ "lazyvim.plugins.extras.lang.r" ];

      extraPackages = [
        r-language-server
      ];
    };
  };
}
