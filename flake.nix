{
  description = "A menu loop used to create custom menus from command line tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.03";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: {
    overlay = final: prev: {
      menu = final.callPackage ./. { };
    };
  } // utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      };
    in {
      packages.menu = pkgs.menu;
      defaultPackage = self.packages.${system}.menu;

      devShell = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          menu
          fish less man
          fzf fzy
        ] ++ nixpkgs.lib.optional (system != "x86_64-darwin") rofi;
      };
    });
}
