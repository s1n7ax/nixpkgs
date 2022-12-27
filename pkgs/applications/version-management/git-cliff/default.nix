{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "git-cliff";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "git-cliff";
    rev = "v${version}";
    hash = "sha256-2EaPVNRcSiXN43iazK5MkZ8ytiALlnYRCH2gEtlqBW0=";
  };

  cargoSha256 = "sha256-kWWg3Ul6SzULdW7oOmkz5Lm2FK1vF/TkggrZcNbIzck=";

  # attempts to run the program on .git in src which is not deterministic
  doCheck = false;

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "A highly customizable Changelog Generator that follows Conventional Commit specifications";
    homepage = "https://github.com/orhun/git-cliff";
    changelog = "https://github.com/orhun/git-cliff/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ siraben ];
  };
}
