{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.util.chezmoi;
in
{
  options.programs.lazyvim.util.chezmoi = {
    enable = mkEnableOption "Chezmoi dotfiles manager support";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.util.chezmoi" ];
  };
}
