{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.svelte;
in
{
  options.programs.lazyvim.lang.svelte = {
    enable = mkEnableOption "language svelte";
  };

  config = mkIf cfg.enable {
    programs.lazyvim.imports = [ "lazyvim.plugins.extras.lang.svelte" ];
  };
}
