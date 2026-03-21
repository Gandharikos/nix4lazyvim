{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.lang.terraform;
in
{
  options.programs.lazyvim.lang.terraform = {
    enable = mkEnableOption "language terraform";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      imports = [ "lazyvim.plugins.extras.lang.terraform" ];

      extraPackages = with pkgs; [
        terraform
        terraform-ls
      ];
    };
  };
}
