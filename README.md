# nix4lazyvim

Nix flake providing a home-manager module for declarative LazyVim configuration.

Inspired by @[azuwis](https://github.com/azuwis)'s Nix setup and [lazyvim-nix](https://github.com/pfassina/lazyvim-nix/blob/main/README.md).

## Features

- 🎯 **Declarative Configuration** - Manage LazyVim entirely through Nix
- 📦 **No Mason** - All plugins and tools managed via nixpkgs
- 🔧 **Simple Extras** - Enable any LazyVim extra with `.enable = true` - no module needed
- 🤖 **Auto-sync** - Automatically tracks LazyVim extras (300+ available)
- 🏠 **Home-manager Integration** - Seamless integration with home-manager
- ⚡ **Data-driven** - Uses JSON metadata, not hand-written modules

## Quick Start

### As a home-manager module

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nix4lazyvim.url = "github:yourusername/nix4lazyvim";
  };

  outputs = { nixpkgs, home-manager, nix4lazyvim, ... }: {
    homeConfigurations.youruser = home-manager.lib.homeManagerConfiguration {
      modules = [
        nix4lazyvim.homeModules.default
        {
          programs.lazyvim = {
            enable = true;

            # Enable specific extras
            extras.lang.rust.enable = true;
            extras.lang.python.enable = true;
            extras.ai.copilot.enable = true;

            appName = "lazyvim";     # Optional: use ~/.config/lazyvim/
            # Also creates a shell alias: lazyvim='NVIM_APPNAME=lazyvim nvim'

            # Choose your tools
            cmp = "blink.cmp";      # or "nvim-cmp" or "auto"
            picker = "telescope";    # or "fzf" or "snacks" or "auto"
            explorer = "neo-tree";   # or "snacks" or "auto"
          };
        }
      ];
    };
  };
}
```

### Standalone (for testing)

```bash
# Run LazyVim directly
nix run github:yourusername/nix4lazyvim

# Or build locally
nix build
./result/bin/nvim
```

## Available Extras

LazyVim extras are organized by category:

- **ai/** - AI assistants (copilot, codeium, avante, etc.)
- **coding/** - Completion, snippets, text manipulation
- **dap/** - Debug Adapter Protocol
- **editor/** - Editor enhancements (telescope, fzf, neo-tree, etc.)
- **formatting/** - Code formatters (prettier, black, etc.)
- **lang/** - 48+ language support modules
- **linting/** - Linters (eslint, etc.)
- **lsp/** - LSP configurations
- **test/** - Testing frameworks
- **ui/** - UI enhancements
- **util/** - Utilities (gitui, chezmoi, etc.)

Enable any extra with:

```nix
programs.lazyvim.extras.<category>.<name>.enable = true;
```

## Configuration Options

```nix
programs.lazyvim = {
  enable = true;                    # Enable LazyVim

  neovim = pkgs.neovim;            # Override Neovim package

  appName = "nvim";                # Config dir name, defaults to ~/.config/nvim/
                                   # If not "nvim", also creates a shell alias named <appName>

  configDir = ./nvim-config;        # Path to your lua/ config directory

  extraPlugins = [ ... ];           # Add plugins beyond LazyVim core
  excludePlugins = [ ... ];         # Drop core or metadata-provided plugins

  installDependencies = true;       # Default dependency policy for enabled extras
  extraPackages = [ ... ];          # Add system tools

  cmp = "auto";                     # Completion: "nvim-cmp" | "blink.cmp" | "auto"
  picker = "auto";                  # Picker: "telescope" | "fzf" | "snacks" | "auto"
  explorer = "auto";                # Explorer: "neo-tree" | "snacks" | "auto"

  extras = {
    # Enable any LazyVim extra - all 300+ extras are auto-discovered
    lang.rust.enable = true;
    lang.python.enable = true;
    lang.go.enable = true;
    ai.copilot.enable = true;
    editor.dial.enable = true;
    lang.php.installDependencies = false;  # Per-extra override
    # No need to write Nix modules - extras are data-driven!
  };
};
```

### Using Custom Configuration

Create a directory with your LazyVim configuration:

```
my-nvim-config/
├── lua/
│   ├── config/
│   │   ├── options.lua   # Vim options
│   │   ├── keymaps.lua   # Custom keymaps
│   │   └── autocmds.lua  # Auto commands
│   └── plugins/
│       └── *.lua         # Plugin configurations
└── (other dirs/files as needed)

Note: Do NOT include `init.lua`; the module generates it.
      Do not commit `lazyvim.json`; LazyVim creates it at runtime and this module excludes it from `configDir`.
```

Then reference it in your home-manager config:

```nix
programs.lazyvim = {
  enable = true;
  configDir = ./my-nvim-config;  # Symlinked to ~/.config/<appName>/ (default: nvim)
};
```

If you keep a `lazy-lock.json`, place it inside `configDir` and Nix will symlink it like the rest of your config.

See `examples/custom-config/` for a complete example.
See `examples/with-dotfiles-config.nix` for a dotfiles-based setup that maps shell `~/.dotfiles/config/nvim` to a Nix path.

## Maintaining This Project

Maintain the metadata in `source/` directly. In practice:

- Update `source/extras.json` when syncing supported LazyVim extras.
- Update `source/plugins.json` when the core plugin set changes.
- Update `source/dependencies.json` when `installDependencies` mappings change.
- Update `source/version.txt` when you want to record the tracked LazyVim revision.

### Using extras

Just enable them in your config:

```nix
programs.lazyvim.extras.lang.python.enable = true;
```

Enabled extras install mapped dependencies by default. To opt one out:

```nix
programs.lazyvim.extras.lang.python.installDependencies = false;
```

If you need additional tools beyond the mappings, add them to `extraPackages`:

```nix
programs.lazyvim.extraPackages = with pkgs; [
  ruff         # Python formatter/linter
  pyright      # Python LSP
];
```

### Find nixpkgs packages

```bash
# Search for vim plugins
nix search nixpkgs#vimPlugins.rust

# Search for system packages
nix search nixpkgs rust-analyzer
```

## Project Structure

```
nix4lazyvim/
├── flake.nix                   # Flake definition
├── nix/
│   ├── default.nix             # Home-manager module entry
│   ├── module.nix              # Main module (data-driven)
│   ├── package.nix             # Standalone package
│   ├── lib/
│   │   └── data-loading.nix    # JSON data loading utilities
└── source/                     # Manually maintained metadata
    ├── extras.json             # All available LazyVim extras (300+)
    ├── dependencies.json       # Extra dependency mappings for installDependencies
    └── version.txt             # LazyVim version
```

## How It Works

1. **Plugin Management**: Instead of Mason, all vim plugins come from `nixpkgs.vimPlugins`
2. **Lazy.nvim Integration**: Uses `dev.path` to point lazy.nvim to Nix store
3. **System Tools**: LSPs, formatters, etc. are in `extraPackages` (added to PATH)
4. **Data-driven Extras**:
   - `source/extras.json` lists supported LazyVim extras plus plugin add/remove metadata
   - `nix/lib/data-loading.nix` loads the JSON and provides helper functions
   - Main module dynamically creates options for all extras
   - When you enable an extra, it adds the import path to lazy.nvim spec and any mapped plugins to `dev.path`
   - **No manual module creation needed** - all 300+ extras work automatically!

## Contributing

1. Update `source/` metadata for the change you are making
2. Test the changes with `nix flake check` and `nix build`
3. Update documentation if needed
4. Submit a PR

That's it! Since extras are data-driven, new LazyVim extras are automatically supported.

## Why This Exists

LazyVim is excellent but uses Mason for package management, which doesn't fit well in NixOS environments. This project provides a pure Nix alternative that:

- Works perfectly on NixOS
- Provides reproducible configurations
- Integrates with home-manager
- Maintains compatibility with LazyVim's structure

## See Also

- [LazyVim](https://github.com/LazyVim/LazyVim) - The upstream project
- [home-manager](https://github.com/nix-community/home-manager) - For managing user configurations
- [nixpkgs](https://github.com/NixOS/nixpkgs) - Where vim plugins come from

## License

MIT
