{ pkgsPath ? ./nixpkgs.nix }:

let
  release = import ./release.nix { inherit pkgsPath; };
in release.build
