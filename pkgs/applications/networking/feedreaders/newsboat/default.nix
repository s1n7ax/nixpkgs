{ stdenv, rustPlatform, fetchFromGitHub, stfl, sqlite, curl, gettext, pkgconfig, libxml2, json_c, ncurses
, asciidoc, docbook_xml_dtd_45, libxslt, docbook_xsl, libiconv, Security, makeWrapper }:

rustPlatform.buildRustPackage rec {
  pname = "newsboat";
  version = "2.19";

  src = fetchFromGitHub {
    owner = "newsboat";
    repo = "newsboat";
    rev = "r${version}";
    sha256 = "0yyrq8a90l6pkrczm9qvdg75jhsdq0niwp79vrdpm8rsxqpdmfq7";
  };

  cargoSha256 = "1q3jf3d80c0ik38qk8jgbhfz5jxv0cy3lzmkyh2l002azp9hvv59";

  postPatch = ''
    substituteInPlace Makefile --replace "|| true" ""
    # Allow other ncurses versions on Darwin
    substituteInPlace config.sh \
      --replace "ncurses5.4" "ncurses"
  '';

  nativeBuildInputs = [ pkgconfig asciidoc docbook_xml_dtd_45 libxslt docbook_xsl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ makeWrapper libiconv ];

  buildInputs = [ stfl sqlite curl gettext libxml2 json_c ncurses ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;

  postBuild = ''
    make
  '';

  NIX_CFLAGS_COMPILE = "-Wno-error=sign-compare"
    + stdenv.lib.optionalString stdenv.isDarwin " -Wno-error=format-security";

  doCheck = true;

  checkPhase = ''
    make test
  '';

  postInstall = ''
    make prefix="$out" install
    cp -r contrib $out
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    for prog in $out/bin/*; do
      wrapProgram "$prog" --prefix DYLD_LIBRARY_PATH : "${stfl}/lib"
    done
  '';

  meta = with stdenv.lib; {
    homepage    = https://newsboat.org/;
    description = "A fork of Newsbeuter, an RSS/Atom feed reader for the text console";
    maintainers = with maintainers; [ dotlambda nicknovitski ];
    license     = licenses.mit;
    platforms   = platforms.unix;
  };
}
