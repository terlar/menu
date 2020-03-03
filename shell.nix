{ pkgs ? import ./nixpkgs.nix {} }:

let
  drv = import ./. { inherit pkgs; };
in pkgs.mkShell {
  buildInputs = [pkgs.man pkgs.less pkgs.fish drv];
}
