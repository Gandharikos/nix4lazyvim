{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption mkPackageOption;
  inherit (lib.modules) mkIf;
  cfg = config.my.neovim;
in
{
  imports = [ ./lazyvim ];

  options.my.neovim = {
    enable = mkEnableOption "neovim" // {
      default = true;
    };

    package = mkPackageOption pkgs "neovim" { } // {
      description = ''
        The neovim package to use. Override to use neovim-nightly:
          my.neovim.package = inputs.neovim-nightly-overlay.packages.''${pkgs.stdenv.hostPlatform.system}.default;
      '';
    };
  };

  config = mkIf cfg.enable {
    # Clear all caches
    # rm -rf ~/.cache/nvim/ ~/.local/share/nvim/lazy/ ~/.local/share/nvim/nvchad/
    # Clear old luac cache
    # find ~/.cache/nvim/luac -type f -mtime +1 -delete

    programs.neovim = {
      enable = true;
      package = cfg.package;

      withNodeJs = false;
      withRuby = false;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
  };
}
