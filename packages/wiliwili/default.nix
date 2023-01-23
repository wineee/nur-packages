{ lib
, stdenv
, fetchFromGitHub
, libsForQt515
, pkg-config
, cmake
, mpv
, python3
, xorg
, SDL2
}:
let
  wrapQtAppsHook = libsForQt515.qt5.wrapQtAppsHook;
  inherit ((builtins.getFlake "github:NixOS/nixpkgs/23485f23ff8536592b5178a5d244f84da770bc87").legacyPackages.${stdenv.system}) curl;
in
stdenv.mkDerivation rec {
  pname = "wiliwili";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "xfangfang";
    repo = "wiliwili";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-D6n7DBlPxAOgvxTAYZcJJboa4wnSi42vPnFjssejfY8=";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook python3 ];

  buildInputs = [ 
    mpv
    curl
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
    #SDL2
  ];

  cmakeFlags = [
    "-DPLATFORM_DESKTOP=ON"
    "-DWIN32_TERMINAL=OFF"
    "-DINSTALL=ON"
    #"-DUSE_SDL2=ON"
  ];

  meta = with lib; {
    description = "Yet another Bilibili client";
    homepage = "https://github.com/xfangfang/wiliwili";
    license = licenses.mit;
  };
}

