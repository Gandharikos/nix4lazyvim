# Example configuration using configDir for custom LazyVim configuration
# This shows how to maintain your LazyVim config files alongside home-manager

{ pkgs, ... }:

{
  programs.lazyvim = {
    enable = true;

    # Point to your custom configuration directory
    # The directory should contain a lua/ subdirectory
    configDir = ./custom-config;

    # Choose your tools
    cmp = "blink.cmp";
    picker = "telescope";
    explorer = "neo-tree";

    # Enable LazyVim extras
    extras = {
      lang.nix.enable = true;
      lang.python.enable = true;
      lang.rust.enable = true;
      ai.copilot.enable = true;
    };

    # Add system tools
    extraPackages = with pkgs; [
      # Language servers
      nil
      pyright
      rust-analyzer

      # Formatters
      nixfmt-rfc-style
      black
      rustfmt

      # Linters
      statix
      ruff
    ];
  };
}
