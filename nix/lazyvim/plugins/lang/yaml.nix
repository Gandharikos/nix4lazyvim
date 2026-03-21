{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.yaml;
in
{
  options.programs.lazyvim.lang.yaml = {
    enable = mkEnableOption "language yaml";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        SchemaStore-nvim
      ];
      imports = [ "lazyvim.plugins.extras.lang.yaml" ];
      extraPackages = with pkgs; [
        yaml-language-server
      ];
    };
  };
}
