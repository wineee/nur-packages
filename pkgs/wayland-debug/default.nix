{ lib
, fetchFromGitHub
, stdenv
, python3
}:

stdenv.mkDerivation rec {
  pname = "wayland-debug";
  version = "0-unstable-2024-12-11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wmww";
    repo = "wayland-debug";
    rev = "06182981d39ab39ed48d91666565767d48dd1007";
    hash = "sha256-R1cUnzabxyoSj28SXXEJW5crfpNsPcwuAo8UK/4/VKg=";
  };

  nativeBuildInputs = [
     python3.pkgs.wrapPython
  ];

  dependencies = with python3.pkgs; [
  ];

  installPhase = ''
    patchShebangs *
    substituteInPlace main.py \
      --replace-fail '/usr/bin/python3' '/usr/bin/env python3'

    mkdir -p $out/lib
    mv * $out/lib
    mkdir -p $out/bin
    ln -s $out/lib/main.py $out/bin/wayland-debug
    wrapPythonPrograms
  '';

  meta = {
    description = "Command line tool to help debug Wayland clients and servers";
    homepage = "https://github.com/wmww/wayland-debug";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rewine ];
    mainProgram = "wayland-debug";
  };
}

