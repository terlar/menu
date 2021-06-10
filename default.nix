{ lib, stdenv, emacs, moreutils }:

stdenv.mkDerivation rec {
  pname = "menu";
  version = lib.strings.fileContents ./.version;

  src = ./.;

  buildInputs = [ emacs ];

  postPatch = ''
    substituteInPlace menu --replace 'IFNE="''${IFNE:-ifne}"' "IFNE=${moreutils}/bin/ifne"
    substituteInPlace menu --replace "VERSION=dev" "VERSION=${version}"
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/man/man1,share/fish/vendor_completions.d}

    cp menu plugins/* $out/bin
    cp completion/menu.fish $out/share/fish/vendor_completions.d

    emacs -Q --batch doc/menu.org -l org -l ox-man -f org-man-export-to-man
    cp doc/menu.man $out/share/man/man1
  '';

  meta = with lib; {
    description = "A menu loop used to create custom menus from command line tools.";
    homepage = "https://github.com/terlar/menu";
    license = licenses.mit;
    maintainers = with maintainers; [ terlar ];
  };
}
