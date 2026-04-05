# Data loading utilities for nix4lazyvim
{ lib, pkgs }:

rec {
  # Load extras metadata (category, name, import path)
  extrasMetadata = builtins.fromJSON (builtins.readFile ../../source/extras.json);

  # Load extras dependencies (plugins, packages)
  extrasDependencies = builtins.fromJSON (builtins.readFile ../../source/dependencies.json);

  # Load core plugins list
  pluginsData = builtins.fromJSON (builtins.readFile ../../source/plugins.json);

  # Convert plugins data to actual vim plugin packages
  getCorePlugins =
    let
      # Convert a single plugin entry to a package or attrset
      convertPlugin = pluginData:
        let
          # Handle special cases like nvim-treesitter.withAllGrammars
          pkg = if pluginData.special or null == "withAllGrammars" then
            pkgs.vimPlugins.nvim-treesitter.withAllGrammars
          else
            pkgs.vimPlugins.${pluginData.nixpkg};
        in
        # If the plugin name differs from the package name, return an attrset
        if pluginData.name != pluginData.nixpkg && pluginData.special or null == null then
          {
            name = pluginData.name;
            path = pkg;
          }
        else
          pkg;
    in
    builtins.map convertPlugin pluginsData.core;

  # Resolve a dotted nixpkgs attribute path like "python3Packages.ruff"
  resolvePackage = pkgName:
    let
      resolved = lib.attrByPath (lib.splitString "." pkgName) null pkgs;
    in
    if resolved != null && lib.isDerivation resolved then resolved else null;

  getPackagesForTools = tools:
    lib.unique (
      lib.filter
        (pkg: pkg != null)
        (lib.flatten (
          map
            (
              tool:
              (lib.optional (tool ? nixpkg) (resolvePackage tool.nixpkg))
              ++ map
                (dep: resolvePackage dep.nixpkg)
                (lib.filter (dep: dep ? nixpkg) (tool.runtime_dependencies or [ ]))
            )
            tools
        ))
    );

  getCoreDependencyPackages = getPackagesForTools (extrasDependencies.core or [ ]);

  # Helper to get all available extras as a list
  # Returns: [ { category = "lang"; name = "python"; import = "lazyvim.plugins.extras.lang.python"; } ... ]
  getAllExtras =
    let
      processCategory = categoryName: categoryExtras:
        lib.mapAttrsToList
          (extraName: extraData: extraData)
          categoryExtras;
      allCategories = lib.mapAttrsToList processCategory extrasMetadata;
    in
    lib.flatten allCategories;

  # Helper to get enabled extras from config
  # extrasConfig: the cfg.extras attrset
  # Returns: list of { name, category, import }
  getEnabledExtras = extrasConfig:
    let
      processCategory = categoryName: categoryExtras:
        let
          enabledInCategory = lib.filterAttrs
            (extraName: extraConfig: extraConfig.enable or false)
            categoryExtras;
        in
        lib.mapAttrsToList
          (extraName: extraConfig:
            let
              # Normalize hyphens to underscores to match extras.json keys
              normalizedName = builtins.replaceStrings [ "-" ] [ "_" ] extraName;
              metadata = extrasMetadata.${categoryName}.${normalizedName} or null;
            in
            if metadata != null then
              {
                inherit (metadata) name category import;
                config = extraConfig;
              }
            else
              throw "Unknown LazyVim extra: ${categoryName}.${extraName}\nUpdate source/extras.json to sync with latest LazyVim."
          )
          enabledInCategory;

      allCategories = lib.mapAttrsToList processCategory extrasConfig;
    in
    lib.flatten allCategories;

  # Resolve packages from source/dependencies.json for enabled extras that opt in.
  # Unmapped tools or nixpkg paths missing from nixpkgs are skipped.
  getExtraDependencyPackages = enabledExtras:
    lib.unique (
      lib.filter
        (pkg: pkg != null)
        (lib.flatten (
          map
            (
              extra:
              let
                extraKey = "${extra.category}.${extra.name}";
                extraTools = extrasDependencies.extras.${extraKey} or [ ];
              in
              if extra.config.installDependencies or false then
                getPackagesForTools extraTools
              else
                [ ]
            )
            enabledExtras
        ))
    );
}
