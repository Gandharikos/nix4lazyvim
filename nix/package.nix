# Standalone LazyVim package — equivalent to nix4nvchad's nix/nvchad.nix.
# Build with: pkgs.callPackage ./nix/package.nix { inherit pkgs lazyvim-starter; }
# Run with:   nix run github:…
{
  pkgs,
  lib ? pkgs.lib,
  stdenvNoCC ? pkgs.stdenvNoCC,
  makeWrapper ? pkgs.makeWrapper,
  neovim ? pkgs.neovim,
  extraPackages ? [ ],
  extraPlugins ? [ ],
  lazyvim-starter,
}:
let
  defaultPlugins = with pkgs.vimPlugins; [
    LazyVim
    snacks-nvim
    { name = "mini.pairs"; path = mini-nvim; }
    ts-comments-nvim
    { name = "mini.ai"; path = mini-nvim; }
    lazydev-nvim
    tokyonight-nvim
    { name = "catppuccin"; path = catppuccin-nvim; }
    grug-far-nvim
    flash-nvim
    blink-cmp
    friendly-snippets
    which-key-nvim
    gitsigns-nvim
    trouble-nvim
    todo-comments-nvim
    conform-nvim
    nvim-lint
    nvim-treesitter.withAllGrammars
    nvim-treesitter-textobjects
    nvim-ts-autotag
    bufferline-nvim
    lualine-nvim
    noice-nvim
    { name = "mini.icons"; path = mini-nvim; }
    nui-nvim
    snacks-nvim
    nvim-lspconfig
    persistence-nvim
    plenary-nvim
  ];

  mkEntryFromDrv =
    drv:
    if lib.isDerivation drv then { name = lib.getName drv; path = drv; } else drv;

  lazyvimPlugins = pkgs.linkFarm "lazy-plugins" (
    builtins.map mkEntryFromDrv (defaultPlugins ++ extraPlugins)
  );

  initLua = pkgs.writeText "lazyvim-init.lua" ''
    local lazypath = ${builtins.toJSON (toString pkgs.vimPlugins.lazy-nvim)}
    vim.opt.rtp:prepend(lazypath)
    vim.g.lazyvim_check_order = false
    require("lazy").setup({
      change_detection = { notify = false },
      defaults = { lazy = true, version = false },
      ui = { border = "rounded" },
      dev = {
        path = "${lazyvimPlugins}",
        patterns = { "" },
        fallback = true,
      },
      checker = { enabled = false },
      rocks = { enabled = false },
      performance = {
        cache = { enabled = true },
        rtp = {
          disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
        },
      },
      spec = {
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        { import = "plugins" },
        { "jay-babu/mason-nvim-dap.nvim", enabled = false },
        { "mason-org/mason-lspconfig.nvim", enabled = false },
        { "mason-org/mason.nvim", enabled = false },
        { "nvim-treesitter/nvim-treesitter", opts = function(_, opts) opts.ensure_installed = {} end },
      },
    })
  '';

  runtimeDeps = with pkgs; [
    lua
    lua-language-server
    stylua
    vscode-langservers-extracted
    fd
    fzf
    ripgrep
    git
  ] ++ extraPackages ++ [ neovim ];

in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lazyvim";
  version = "unstable";
  src = lazyvim-starter;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = runtimeDeps;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,config}

    # Copy LazyVim starter config (provides lua/config/ and lua/plugins/ skeleton)
    cp -r $src/. $out/config/
    chmod -R u+w $out/config

    # Overwrite the starter's init.lua with our nix-generated one
    cp ${initLua} $out/config/init.lua

    # On first run: copy the config skeleton to ~/.config/nvim so users can customise it
    makeWrapper ${lib.getExe neovim} $out/bin/nvim \
      --run 'd="''${XDG_CONFIG_HOME:-$HOME/.config}/nvim"; [ -d "$d" ] || { mkdir -p "$d"; ${pkgs.coreutils}/bin/cp -r $out/config/. "$d/"; chmod -R u+w "$d"; }' \
      --prefix PATH : '${lib.makeBinPath finalAttrs.buildInputs}'

    runHook postInstall
  '';

  meta = {
    description = "LazyVim — a Neovim configuration for the lazy";
    mainProgram = "nvim";
    platforms = lib.platforms.unix;
  };
})
