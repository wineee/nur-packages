{ lib
, stdenv
, fetchFromGitHub
, libsForQt515
, pkg-config
, libsodium
}:
let 
  qmake = libsForQt515.qmake;
in stdenv.mkDerivation {
  pname = "LANDrop";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "LANDrop";
    repo = "LANDrop";
    rev = "v0.4.0";
    hash = "";
  };

  nativeBuildInputs = [ qmake pkg-config ];
  # buildInputs = [ libsodium.dev ];

  meta = with lib; {
    description = "Drop any files to any devices on your LAN";
    homepage = "https://landrop.app";
    license = licenses.bsd3;
  };
}

