{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.dotnet;
in
{
  options.programs.lazyvim.lang.dotnet = {
    enable = mkEnableOption "language dotnet";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      imports = [ "lazyvim.plugins.extras.lang.dotnet" ];

      extraPackages = with pkgs; [
        omnisharp-roslyn
      ];
    };
  };
}
