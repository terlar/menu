{ pkgsPath ? ./nixpkgs.nix }:

let
  pkgs = import pkgsPath {};
  version = pkgs.lib.removeSuffix "\n" (builtins.readFile ./.version);
  releaseName = "menu-${version}";
in rec {
  manual = pkgs.stdenv.mkDerivation {
    name = "menu-manual";
    inherit version;
    src = ./doc;

    buildInputs = [pkgs.emacs];

    buildPhase = ''
      emacs --batch menu.org -l org -l ox-man -f org-man-export-to-man
    '';

    installPhase = ''
      mkdir -p $out/share/man/man1
      mv menu.man $out/share/man/man1/menu.1
    '';
  };

  tarball = pkgs.releaseTools.sourceTarball {
    name = "menu-tarball";
    inherit version;
    src = ./.;

    postPatch = ''
      substituteInPlace menu --replace 'VERSION=dev' "VERSION=${version}"
    '';

    distPhase = ''
      mkdir -p $out/tarballs
      mkdir -p ${releaseName}/bin ${releaseName}/share/man/man1 ${releaseName}/share/fish/vendor_completions.d

      cp -a menu ${releaseName}/bin/
      cp -a plugins/* ${releaseName}/bin/

      cp -a completion/menu.fish ${releaseName}/share/fish/vendor_completions.d/

      cp -a ${manual}/share/man/man1/* ${releaseName}/share/man/man1/

      tar cvzf $out/tarballs/${releaseName}.tar.gz ${releaseName}
    '';
  };

  build = pkgs.releaseTools.nixBuild {
    name = "menu";
    inherit version;
    src = tarball;

    postPatch = ''
      substituteInPlace bin/menu --replace 'IFNE="''${IFNE:-ifne}"' "IFNE=${pkgs.moreutils}/bin/ifne"
      substituteInPlace bin/menu --replace 'ROFI="''${ROFI:-rofi}"' "ROFI=${pkgs.rofi}/bin/rofi"
      substituteInPlace bin/menu --replace 'FZF="''${FZF:-fzf}"' "FZF=${pkgs.fzf}/bin/fzf"
      substituteInPlace bin/menu --replace 'FZY="''${FZY:-fzy}"' "FZY=${pkgs.fzy}/bin/fzy"
    '';

    installPhase = ''
      mkdir -p $out
      cp -r bin share $out
    '';
  };
}
