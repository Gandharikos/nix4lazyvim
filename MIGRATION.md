# Migration Guide

## Simplification (v0.2.0)

The project has been significantly simplified using a data-driven approach. **No breaking changes** for users!

### What Changed

#### For Users (No Action Required)

Your existing configuration continues to work without changes:

```nix
# This still works exactly the same!
programs.lazyvim = {
  enable = true;
  extras.lang.rust.enable = true;
  extras.ai.copilot.enable = true;
};
```

**What's new:**
- All 300+ LazyVim extras now work automatically (no manual module needed)
- Faster updates to track LazyVim releases
- Simpler codebase

#### For Maintainers

**Before (Manual Module Creation):**
1. Discover new extras in upstream LazyVim
2. Add manual module files for each extra
3. Manually fill in plugins and packages
4. Add import to category's default.nix
5. Test and commit

**After (Data-Driven):**
1. Update the metadata in `source/`
2. Done! All extras are automatically available

### Removed Files/Directories

- `nix/lazyvim/plugins/` - All manual module files (no longer needed)
- `scripts/` - No longer used; metadata is maintained directly in `source/`
- `source/missing-extras.txt` - No longer needed (all extras work)

### New Files

- `nix/lib/data-loading.nix` - JSON data loading utilities
- `source/dependencies.json` - Extra dependency mappings used by `enableDependencies`

### Architecture Changes

**Old approach:**
```
User enables extra → Nix module adds plugins/packages → LazyVim imports extra
```

**New approach:**
```
User enables extra → JSON lookup → LazyVim imports extra
                                 ↓
                     Optional mapped tools auto-install via enableDependencies
```

### Dependency Installation

```nix
programs.lazyvim.enableDependencies = true;
programs.lazyvim.extras.lang.python.enable = true;

# Optional per-extra override
programs.lazyvim.extras.lang.python.enableDependencies = false;
```

### Benefits

1. **300+ extras immediately available** - No waiting for manual modules
2. **Faster LazyVim tracking** - One command to sync
3. **Simpler codebase** - 1000+ lines of module code → 1 JSON file
4. **Easier contributions** - No need to write Nix modules
5. **More maintainable** - Data-driven is easier to understand and update

### If You Encounter Issues

The old module system is preserved in git history:
```bash
git checkout <commit-before-migration>
```

Please report any issues on GitHub!
