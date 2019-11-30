{ pkgsPath ? ./nixpkgs.nix }:

let
  pkgs = import pkgsPath {};
  drv = import ./. { inherit pkgsPath; };
in pkgs.mkShell {
  # Create a shell with all Klarna Packages and some development tools
  buildInputs = [pkgs.man pkgs.less pkgs.fish drv];
}
