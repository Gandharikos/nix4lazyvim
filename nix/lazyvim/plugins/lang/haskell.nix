{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.haskell;
in
{
  options.programs.lazyvim.lang.haskell = {
    enable = mkEnableOption "language haskell";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      imports = [ "lazyvim.plugins.extras.lang.haskell" ];

      extraPackages = with pkgs; [
        ghc
        haskell-language-server
      ];
    };
  };
}
