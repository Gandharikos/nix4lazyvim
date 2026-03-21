{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.ansible;
in
{
  options.programs.lazyvim.lang.ansible = {
    enable = mkEnableOption "language ansible";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      imports = [ "lazyvim.plugins.extras.lang.ansible" ];

      extraPackages = with pkgs; [
        ansible-lint
        ansible-language-server
      ];
    };
  };
}
