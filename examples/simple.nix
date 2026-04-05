# Simple example configuration for nix4lazyvim
# Use this as a template for your home-manager config

{ pkgs, ... }:

{
  programs.lazyvim = {
    enable = true;

    # Enable LazyVim extras (all 109+ extras available!)
    extras = {
      # Language support
      lang.nix.enable = true;
      lang.python.enable = true;
      lang.rust.enable = true;
      lang.go.enable = true;

      # AI assistants
      ai.copilot.enable = true;

      # Editor enhancements
      editor.dial.enable = true;
      editor.illuminate.enable = true;
      editor.telescope.enable = true;
      editor.neo-tree.enable = true;

      # UI improvements
      ui.edgy.enable = true;
    };

    # Add system tools (LSPs, formatters, linters)
    extraPackages = with pkgs; [
      # Language servers
      nil               # Nix LSP
      pyright           # Python LSP
      rust-analyzer     # Rust LSP
      gopls             # Go LSP

      # Formatters
      nixfmt-rfc-style  # Nix formatter
      black             # Python formatter
      rustfmt           # Rust formatter
      gofumpt           # Go formatter

      # Linters
      ruff              # Python linter
      statix            # Nix linter
    ];
  };
}
