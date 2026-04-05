# Repository Guidelines

## Project Structure & Module Organization
This repository is a Nix flake for declarative LazyVim setup. Keep hand-written logic under `nix/`: `nix/default.nix` is the module entry, `nix/module.nix` contains the main Home Manager options, and `nix/package.nix` builds the standalone package. Repository metadata lives in `source/` (`extras.json`, `plugins.json`, `dependencies.json`, `version.txt`). Usage examples live in `examples/`.

## Build, Test, and Development Commands
Use Nix commands from the repo root:

- `nix build` builds the standalone `nvim` package.
- `nix run` launches the packaged LazyVim for quick manual testing.
- `nix flake check` validates the flake outputs and catches evaluation issues.
- `home-manager switch --flake .` is the integration check when testing this module in a local Home Manager setup.

## Coding Style & Naming Conventions
Match the existing Nix style: two-space indentation, trailing semicolons, and one logical option block per section. Prefer lower-case, hyphenated file names (`package.nix`, `data-loading.nix`) and keep user-facing options under the `programs.lazyvim.*` namespace. Update `source/` deliberately and keep metadata changes consistent with the corresponding Nix logic.

## Testing Guidelines
There is no dedicated unit-test suite yet, so verification is command-driven. Run `nix flake check` and `nix build` for every change. For changes to metadata, inspect the diff in `source/` directly. For configuration behavior, verify against `examples/simple.nix`, `examples/with-custom-config.nix`, or `examples/with-dotfiles-config.nix`.

## Commit & Pull Request Guidelines
Recent history uses Conventional Commits such as `feat:` and `refactor:`; keep that format (`fix:`, `docs:`, `chore:`) and make each commit atomic. PRs should explain the user-visible change, list the verification commands you ran, and note whether `source/` was regenerated. Include example config snippets when changing module options or defaults.
