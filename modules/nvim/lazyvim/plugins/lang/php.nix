{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.php;
in
{
  options.programs.lazyvim.php = {
    enable = mkEnableOption "language php";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      imports = [ "lazyvim.plugins.extras.lang.php" ];

      extraPackages = with pkgs; [
        phpactor
        intelephense
        php84Packages.php-codesniffer
        # php84Packages.php-cs-fixer
      ];
    };
  };
}
