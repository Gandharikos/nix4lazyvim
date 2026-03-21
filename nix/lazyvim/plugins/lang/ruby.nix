{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.ruby;
in
{
  options.programs.lazyvim.lang.ruby = {
    enable = mkEnableOption "language ruby";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      imports = [ "lazyvim.plugins.extras.lang.ruby" ];

      extraPackages = with pkgs; [
        rubyPackages.solargraph
      ];
    };
  };
}
