# Data loading utilities for nix4lazyvim
{ lib, pkgs }:

let
  normalizeExtraName = name: builtins.replaceStrings [ "-" ] [ "_" ] name;
  denormalizeExtraName = name: builtins.replaceStrings [ "_" ] [ "-" ] name;

  # Load extras metadata (category, name, import path, plugin metadata)
  extrasMetadata = builtins.fromJSON (builtins.readFile ../../source/extras.json);

  # Load dependency metadata from source/dependencies.json
  extrasDependencies = builtins.fromJSON (builtins.readFile ../../source/dependencies.json);

  # Load core plugins list
  pluginsData = builtins.fromJSON (builtins.readFile ../../source/plugins.json);

  getExtraMetadata =
    categoryName: extraName:
    let
      categoryExtras = extrasMetadata.${categoryName} or { };
      candidates = lib.unique [
        extraName
        (normalizeExtraName extraName)
        (denormalizeExtraName extraName)
      ];
      matchedName = lib.findFirst (candidate: builtins.hasAttr candidate categoryExtras) null candidates;
    in
    if matchedName == null then null else categoryExtras.${matchedName};

  requireExtraMetadata =
    categoryName: extraName:
    let
      metadata = getExtraMetadata categoryName extraName;
    in
    if metadata != null then
      metadata
    else
      throw "Unknown LazyVim extra: ${categoryName}.${extraName}\nUpdate source/extras.json to sync with latest LazyVim.";

  resolveVimPlugin = pluginRef:
    let
      resolved = lib.attrByPath (lib.splitString "." pluginRef) null pkgs.vimPlugins;
    in
    if resolved != null && lib.isDerivation resolved then
      resolved
    else
      throw "Unknown vim plugin `${pluginRef}` referenced in source metadata.";

  convertPluginEntry =
    pluginData:
    if builtins.isString pluginData then
      resolveVimPlugin pluginData
    else
      let
        pkg =
          if (pluginData.special or null) == "withAllGrammars" then
            pkgs.vimPlugins.nvim-treesitter.withAllGrammars
          else
            resolveVimPlugin pluginData.nixpkg;
        pluginName = pluginData.name or pluginData.nixpkg;
      in
      if pluginName != pluginData.nixpkg && (pluginData.special or null) == null then
        {
          name = pluginName;
          path = pkg;
        }
      else
        pkg;

  pluginEntryId =
    pluginData:
    if builtins.isString pluginData then
      "pkg:${pluginData}"
    else if pluginData ? special then
      "special:${pluginData.nixpkg}:${pluginData.special}"
    else if pluginData ? name then
      "named:${pluginData.name}:${pluginData.nixpkg}"
    else
      "pkg:${pluginData.nixpkg}";

  uniquePluginEntries =
    entries:
    (
      lib.foldl'
        (
          acc: entry:
          let
            key = pluginEntryId entry;
          in
          if builtins.elem key acc.keys then
            acc
          else
            {
              keys = acc.keys ++ [ key ];
              values = acc.values ++ [ entry ];
            }
        )
        {
          keys = [ ];
          values = [ ];
        }
        entries
    ).values;

  getPluginEntriesForExtras =
    fieldName: extras:
    uniquePluginEntries (
      lib.flatten (map (extra: extra.${fieldName} or [ ]) extras)
    );

  parseExtraRef =
    ref:
    let
      parts = lib.splitString "." ref;
    in
    if builtins.length parts == 2 then
      {
        category = builtins.elemAt parts 0;
        name = builtins.elemAt parts 1;
      }
    else
      throw "Invalid extra reference `${ref}` in source/extras.json. Expected `<category>.<name>`.";

  mergeExtraConfig =
    left: right:
    {
      enable = true;
      enableDependencies = (left.enableDependencies or false) || (right.enableDependencies or false);
    };

  mergeResolvedExtras =
    extras:
    builtins.attrValues (
      lib.foldl'
        (
          acc: extra:
          let
            key = "${extra.category}.${extra.name}";
          in
          if builtins.hasAttr key acc then
            acc
            // {
              "${key}" = acc.${key} // {
                config = mergeExtraConfig acc.${key}.config extra.config;
              };
            }
          else
            acc // { "${key}" = extra; }
        )
        { }
        extras
    );

  expandResolvedExtra =
    seen: extra:
    let
      key = "${extra.category}.${extra.name}";
      impliedRefs = extra.impliedExtras or [ ];
      impliedExtras =
        lib.flatten (
          map
            (
              ref:
              let
                parsed = parseExtraRef ref;
                impliedExtra =
                  (requireExtraMetadata parsed.category parsed.name)
                  // {
                    config = extra.config;
                  };
              in
              expandResolvedExtra (seen ++ [ key ]) impliedExtra
            )
            (lib.filter (ref:
              let
                parsed = parseExtraRef ref;
                impliedKey = "${parsed.category}.${parsed.name}";
              in
              !(builtins.elem impliedKey (seen ++ [ key ]))
            ) impliedRefs)
        );
    in
    [ extra ] ++ impliedExtras;
in
rec {
  inherit extrasMetadata extrasDependencies pluginsData getExtraMetadata requireExtraMetadata;

  # Convert plugins data to actual vim plugin packages
  getCorePlugins = builtins.map convertPluginEntry pluginsData.core;

  # Resolve a dotted nixpkgs attribute path like "python3Packages.ruff"
  resolvePackage = pkgName:
    let
      resolved = lib.attrByPath (lib.splitString "." pkgName) null pkgs;
    in
    if resolved != null && lib.isDerivation resolved then resolved else null;

  getPackagesForPaths = paths:
    lib.unique (
      lib.filter
        (pkg: pkg != null)
        (map resolvePackage paths)
    );

  getPackagesForDependencySpec =
    spec:
    if builtins.isList spec then
      getPackagesForPaths spec
    else
      getPackagesForPaths ((spec.packages or [ ]) ++ (spec.runtime or [ ]));

  getCoreDependencyPackages = getPackagesForDependencySpec (extrasDependencies.core or [ ]);

  # Helper to get all available extras as a list
  getAllExtras =
    let
      processCategory = categoryName: categoryExtras: lib.mapAttrsToList (_: extraData: extraData) categoryExtras;
      allCategories = lib.mapAttrsToList processCategory extrasMetadata;
    in
    lib.flatten allCategories;

  # Helper to get enabled extras from config
  getEnabledExtras = extrasConfig:
    let
      explicitExtras =
        let
          processCategory = categoryName: categoryExtras:
            let
              enabledInCategory = lib.filterAttrs (_: extraConfig: extraConfig.enable or false) categoryExtras;
            in
            lib.mapAttrsToList
              (
                extraName: extraConfig:
                (requireExtraMetadata categoryName extraName)
                // {
                  config = extraConfig;
                }
              )
              enabledInCategory;

          allCategories = lib.mapAttrsToList processCategory extrasConfig;
        in
        lib.flatten allCategories;

      expandedExtras = lib.flatten (map (extra: expandResolvedExtra [ ] extra) explicitExtras);
    in
    mergeResolvedExtras expandedExtras;

  getExtraPluginPackages =
    extras: builtins.map convertPluginEntry (getPluginEntriesForExtras "extraPlugins" extras);

  getExcludedPluginPackages =
    extras: builtins.map convertPluginEntry (getPluginEntriesForExtras "excludePlugins" extras);

  # Resolve package paths from source/dependencies.json for enabled extras that opt in.
  # Missing nixpkgs paths are skipped.
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
                extraDependencySpec = extrasDependencies.extras.${extraKey} or [ ];
              in
              if extra.config.enableDependencies or false then
                getPackagesForDependencySpec extraDependencySpec
              else
                [ ]
            )
            enabledExtras
        ))
    );
}
