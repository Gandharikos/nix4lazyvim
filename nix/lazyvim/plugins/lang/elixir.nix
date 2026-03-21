{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.elixir;
in
{
  options.programs.lazyvim.lang.elixir = {
    enable = mkEnableOption "language elixir";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.lang.elixir" ];
  };
}
