{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.ocaml;
in
{
  options.programs.lazyvim.lang.ocaml = {
    enable = mkEnableOption "language ocaml";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.lang.ocaml" ];
  };
}
