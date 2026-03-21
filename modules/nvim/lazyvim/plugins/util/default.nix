{ lib, nix4lazyvimLib, ... }:
{
  imports = nix4lazyvimLib.scanPaths ./.;
}
