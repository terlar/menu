{ pkgs ? import <nixpkgs> {} }:

let
  release = import ./release.nix { inherit pkgs; };
in release.build
