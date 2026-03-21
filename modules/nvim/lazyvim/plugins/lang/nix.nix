{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.nix;
in
{
  options.programs.lazyvim.nix = {
    enable = mkEnableOption "language nix";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPackages = with pkgs; [
        nil
        nixfmt
      ];
      # programs.lazyvim.extraSpec = ''
      #   { import = "lazyvim.plugins.extras.lang.nix" },
      # '';
      config = [ "lang/nix.lua" ];
    };
  };
}
