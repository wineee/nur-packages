{ lib
, stdenv
, fetchurl
, electron
, makeWrapper
}:
stdenv.mkDerivation rec {
  pname = "electron-netease-cloud-music";
  version = "0.9.34";

  src = fetchurl {
    url = "https://github.com/Rocket1184/electron-netease-cloud-music/releases/download/v${version}/electron-netease-cloud-music_v${version}.asar";
    sha256 = "sha256-8yX4VJ/QfAnXaSNPmxN9AquRuvJ/YU+L8kb/z/rEGG0=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];
  
  dontUnpack = true;

  installPhase = ''
    install -D $src $out/opt/${pname}_v${version}.asar
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/opt/${pname}_v${version}.asar
  '';

  meta = with lib; {
    description = "UNOFFICIAL client for music.163.com. Powered by Electron and Vue
";
    homepage = "https://ncm-releases.herokuapp.com";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux"];
  };
}

