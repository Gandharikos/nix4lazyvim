# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**nix4lazyvim** is a Nix flake that provides a home-manager module for configuring LazyVim (a Neovim distribution). It enables declarative, reproducible LazyVim configurations with Nix, including:
- Plugin management via Nix packages (bypassing Mason)
- Language server and tool installation via `extraPackages`
- Modular extras system for enabling LazyVim plugins by category

## Flake Structure

The flake provides two main outputs:

1. **`homeModules.default`** — Import into home-manager configurations
   - Entry point: `nix/default.nix` → `nix/module.nix`
   - Configurable via `programs.lazyvim.*` options

2. **`packages.default`** — Standalone LazyVim package (for testing)
   - Built via `nix/package.nix`
   - Run with: `nix run github:yourusername/nix4lazyvim`

## Key Commands

### Building and Testing
```bash
# Build the standalone package
nix build

# Run the standalone LazyVim
nix run

# Check flake for errors
nix flake check

# Update flake inputs
nix flake update

# Test in home-manager (if integrated)
home-manager switch --flake .
```

### Development
```bash
# Format Nix files (if nixfmt/alejandra available)
nixfmt **/*.nix
# or
alejandra .

# Search for specific plugin usage
rg "plugin-name" nix/
```

## Architecture

### Module System (`nix/`)

The home-manager module (`nix/module.nix`) is **data-driven** and exposes:

**User-facing options:**
- **`programs.lazyvim.enable`** — Enable LazyVim
- **`programs.lazyvim.neovim`** — Override Neovim package (for nightly, etc.)
- **`programs.lazyvim.appName`** — Config directory name / `NVIM_APPNAME` value (default: `nvim`)
- **`programs.lazyvim.configDir`** — Path to custom lua/ config directory (symlinked under `~/.config/<appName>/`)
- **`programs.lazyvim.extraPlugins`** — Add plugins beyond LazyVim core (core plugins auto-loaded from source/plugins.json)
- **`programs.lazyvim.excludePlugins`** — Remove core or metadata-provided plugins from the generated dev.path
- **`programs.lazyvim.installDependencies`** — Default dependency-install policy for enabled extras (default: `true`)
- **`programs.lazyvim.extraPackages`** — System tools/LSPs to include in PATH
- **`programs.lazyvim.extras.{category}.{name}.enable`** — Enable LazyVim extras (auto-discovered from JSON)
- **`programs.lazyvim.extras.{category}.{name}.installDependencies`** — Per-extra override for mapped tools and runtime dependencies
- **`programs.lazyvim.cmp`** — Completion engine (nvim-cmp/blink.cmp/auto)
- **`programs.lazyvim.picker`** — Picker (telescope/fzf/snacks/auto)
- **`programs.lazyvim.explorer`** — File explorer (neo-tree/snacks/auto)

### Data-Driven Architecture

**Everything is data-driven!** No manual module creation needed for extras or core plugins.

#### 1. Core Plugins (`source/plugins.json`)

Core LazyVim plugins are automatically loaded from JSON:

```json
{
  "core": [
    {
      "name": "LazyVim",
      "nixpkg": "LazyVim",
      "description": "LazyVim core plugin"
    },
    {
      "name": "mini.pairs",
      "nixpkg": "mini-nvim",
      "description": "Auto pairs from mini.nvim"
    }
    // ... 27 core plugins total
  ]
}
```

**Loaded automatically:** `dataLib.getCorePlugins` converts JSON → Nix packages

#### 2. LazyVim Extras (`source/extras.json`)

All 109+ LazyVim extras are auto-discovered:

```json
{
  "lang": {
    "python": {
      "category": "lang",
      "name": "python",
      "import": "lazyvim.plugins.extras.lang.python"
    }
  }
}
```

**How it works:**
1. `source/extras.json` records the supported extras metadata, including plugin additions/removals
2. `nix/lib/data-loading.nix` loads and parses the JSON
3. Main module dynamically generates options for all extras
4. Enabling an extra adds its import path to lazy.nvim spec and any mapped plugins to `dev.path`

**Result:** All extras and core plugins work automatically, zero manual modules!

### Key Files

**Core:**
- **`flake.nix`** — Flake definition with module, package, and app outputs
- **`nix/default.nix`** — Entry point for home-manager module
- **`nix/module.nix`** — Main module with data-driven options and logic
- **`nix/lib/data-loading.nix`** — JSON data loading and helper functions
- **`nix/package.nix`** — Standalone LazyVim package builder

**Metadata (manually maintained):**
- **`source/plugins.json`** — Core LazyVim plugins (27 plugins)
- **`source/extras.json`** — All LazyVim extras metadata (109+ extras)
- **`source/dependencies.json`** — Extra dependency mappings used by `installDependencies`
- **`source/version.txt`** — LazyVim version

### How It All Works (Fully Data-Driven!)

#### 1. Core Plugins Loading

```nix
# source/plugins.json + source/extras.json → allPlugins
allPlugins =
  lib.subtractLists (excludedPluginPackages ++ cfg.excludePlugins) dataLib.getCorePlugins
  ++ extraPluginPackages
  ++ cfg.extraPlugins;
```

**Flow:**
```
source/plugins.json + source/extras.json → data-loading.nix → Nix packages → linkFarm → lazy.nvim dev.path
```

#### 2. LazyVim Extras Loading

**User config:**
```nix
programs.lazyvim = {
  enable = true;
  extras.lang.rust.enable = true;
  extras.ai.copilot.enable = true;
};
```

**Data processing:**
```nix
# 1. Filter enabled extras
enabledExtras = dataLib.getEnabledExtras cfg.extras;
# Result: [{ name = "rust"; category = "lang"; import = "lazyvim.plugins.extras.lang.rust"; } ...]

# 2. Generate Lua spec
extraImportSpec = lib.concatMapStrings
  (extra: ''{ import = "${extra.import}" },
  '')
  enabledExtras;
# Result: { import = "lazyvim.plugins.extras.lang.rust" },
```

**Flow:**
```
extras config → getEnabledExtras → extraImportSpec → initLua → lazy.nvim
```

#### 3. initLua Integration

The generated `initLua`:
- Points `dev.path` to `lazyvimPlugins` (Nix store symlinks)
- Inserts generated extra imports into lazy.nvim spec
- Disables Mason (all plugins/tools from Nix)
- Empties treesitter `ensure_installed` (grammars from Nix)

**Complete data flow:**
```
User config
    ↓
source/plugins.json → Core plugins
source/extras.json  → Extra imports + plugin mappings
    ↓
Data loading (nix/lib/data-loading.nix)
    ↓
Main module (nix/module.nix)
    ↓
initLua with lazy.nvim config
    ↓
LazyVim running with Nix-managed plugins
```

**Note:** Extras always add import paths. `installDependencies = true` additionally installs mapped tools from `source/dependencies.json`; unmapped tools still need manual `extraPackages`.

### Metadata Files

**`source/extras.json`** - Complete metadata for all LazyVim extras, including plugin mappings (300+)
```json
{
  "lang": {
    "python": {
      "category": "lang",
      "name": "python",
      "import": "lazyvim.plugins.extras.lang.python",
      "extraPlugins": ["venv-selector-nvim"]
    }
  }
}
```

**`source/version.txt`** - LazyVim version and update timestamp

**`source/dependencies.json`** - Tool dependency mappings for each extra

**Note:** `source/` is maintained directly in this repository.

## Using Custom Configuration (configDir)

You can maintain your LazyVim configuration files outside of the module using `configDir`:

### Directory Structure

```
my-config/
├── lua/
│   ├── config/           # LazyVim config overrides
│   │   ├── options.lua   # Vim options
│   │   ├── keymaps.lua   # Custom keymaps
│   │   ├── autocmds.lua  # Auto commands
│   │   └── lazy.lua      # Lazy.nvim overrides (optional)
│   └── plugins/          # Custom plugin specs
│       ├── colorscheme.lua
│       └── ...
├── ftplugin/             # Filetype plugins (optional)
└── after/                # After directory (optional)

DO NOT INCLUDE in `configDir`:
  ✗ init.lua              # Auto-generated
  ✗ lazyvim.json          # Generated by LazyVim at runtime
```

### Usage

```nix
programs.lazyvim = {
  enable = true;
  configDir = ./my-config;  # Points to config directory
  appName = "lazyvim";      # Uses ~/.config/lazyvim/
  
  # Module handles plugins and extras
  extras.lang.rust.enable = true;
  extraPackages = [ pkgs.rust-analyzer ];
};
```

### How It Works

1. **Module generates init.lua** - Sets up lazy.nvim with Nix-managed plugins
2. **All configDir files are symlinked** - To `~/.config/<appName>/` (except excluded files)
3. **Excluded files**:
   - `init.lua` - Generated by module
   - `lazyvim.json` - Generated by LazyVim at runtime and excluded here
4. **LazyVim loads your files** - Following standard loading order

### Example Files

See `examples/custom-config/` for complete examples of:
- `lua/config/options.lua` - Custom vim options
- `lua/config/keymaps.lua` - Custom keymaps
- `lua/plugins/colorscheme.lua` - Plugin configuration overrides

## Using LazyVim Extras

All LazyVim extras are automatically available! No need to create Nix modules.

**To use an extra:**

1. **Enable it** in your home-manager config:
   ```nix
   programs.lazyvim.extras.lang.ruby.enable = true;
   ```

2. **Add required tools** to `extraPackages` (if needed):
   ```nix
   programs.lazyvim.extraPackages = with pkgs; [
     ruby-lsp        # Ruby language server
     rubocop         # Ruby linter
   ];
   ```

3. **Test**: `home-manager switch` or `nix build`

**To discover new extras:**

```bash
# Check source/extras.json for available extras
cat source/extras.json | jq '.lang | keys'
```

`installDependencies = true` installs the mapped packages from `source/dependencies.json`

## Nix Patterns Used

- **Plugin specification**: Plugins can be either:
  - A derivation: `pkgs.vimPlugins.lazy-nvim`
  - An attrset: `{ name = "mini.ai"; path = pkgs.vimPlugins.mini-nvim; }`

- **linkFarm**: Used to create a directory of symlinks to plugins that lazy.nvim can discover

- **Lua generation**: `initLua` is a string-interpolated Lua script generated from Nix options

- **subtractLists**: Used to implement `excludePlugins` by removing unwanted defaults

## Plugin Discovery

To find which vim plugins are available in nixpkgs:
```bash
# Search nixpkgs for vim plugins
nix search nixpkgs vimPlugins.{plugin-name}

# Or browse online
https://search.nixos.org/packages?channel=unstable&query=vimPlugins
```

## Common Issues

### Mason conflicts
This module disables Mason because all plugins/tools are managed by Nix. If a LazyVim extra expects Mason, ensure the equivalent packages are in `extraPackages`.

### Plugin version mismatches
If you need a lockfile, keep `lazy-lock.json` directly in your `configDir` so Nix symlinks it into `~/.config/<appName>/`:
```nix
programs.lazyvim.configDir = ./my-config;
```

### Treesitter grammars
All grammars are provided via `nvim-treesitter.withAllGrammars`. The module sets `ensure_installed = {}` to prevent runtime downloads.
