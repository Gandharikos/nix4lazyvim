{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.astro;
in
{
  options.programs.lazyvim.astro = {
    enable = mkEnableOption "language astro";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      typescript.enable = true;

      imports = [ "lazyvim.plugins.extras.lang.astro" ];

      extraPackages = with pkgs; [
        astro-language-server
      ];
    };
  };
}
