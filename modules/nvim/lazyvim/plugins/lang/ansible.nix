{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.ansible;
in
{
  options.programs.lazyvim.ansible = {
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
