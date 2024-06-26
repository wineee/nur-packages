{ lib
, stdenv
, fetchFromGitHub
, libsForQt5
}:
stdenv.mkDerivation {
  pname = "GraphBuilder";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "Linloir";
    repo = "GraphBuilder";
    rev = "6309cce3826759bde652cb2d962fae22ec8e7a19";
    hash = "sha256-Dh1SoOV6enmlU/BBAigmfXZNJraPrfXUt97bp8edwPU=";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
  ];

  installPhase = ''
    install -D GraphBuilder $out/bin/graphbuilder
  '';

  meta = with lib; {
    description = "A visualized tool to create a graph";
    homepage = "https://github.com/Linloir/GraphBuilder";
    license = licenses.mit;
  };
}

