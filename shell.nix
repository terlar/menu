{ pkgsPath ? ./nixpkgs.nix }:

let
  pkgs = import pkgsPath {};
  drv = import ./. { inherit pkgsPath; };
in pkgs.mkShell {
  buildInputs = [pkgs.man pkgs.less pkgs.fish drv];
}
