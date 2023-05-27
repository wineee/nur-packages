{ lib
, stdenv
, fetchFromGitHub
, guile_1_8, qtbase, xmodmap, which, freetype,
  libjpeg,
  sqlite,
  aspell,
  git,
  python3
, pkg-config
, cmake
, xmake
, wrapQtAppsHook
, unzip
, curl
, zlib
, bzip2
, libpng
, brotli
, libiconv
, pdfhummus
, qtsvg
}:

stdenv.mkDerivation rec {
  pname = "mogan";
  version = "1.2.0-alpha6";

  src = fetchFromGitHub {
    owner = "XmacsLabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-M17Ca15pnSGAl6dwp5eNZs5q0HbMGMYdB05t1ZBbS0c=";
  };

  #enableParallelBuilding = true;

  patches = [
    ./use-system-lib.patch
    ./fix-build.diff
  ];

  nativeBuildInputs = [
    xmake
    pkg-config
    cmake
    wrapQtAppsHook
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    guile_1_8
    sqlite
    git

    unzip


    ## yes
    freetype
    zlib
    bzip2
    libpng
    libjpeg
    brotli

    libiconv
    pdfhummus
    qtbase
    qtsvg
  ];

  #installFlags = [ "prefix=${placeholder "out"}" ];
  buildPhase = ''
    export HOME=$PWD
    xmake g --network=private
    #xmake f
    xmake build --yes --verbose --diagnosis --all
  '';

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev qtsvg}/include/QtSvg";

  meta = with lib; {
    description = "A structure editor delivered by Xmacs Labs";
    homepage    = "https://mogan.app";
    license     = licenses.gpl3Plus;
    platforms   = platforms.all;
    maintainers = with maintainers; [ rewine ];
  };
}
