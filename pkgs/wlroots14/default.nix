{ lib, stdenv, fetchFromGitLab, meson, ninja, pkg-config, wayland-scanner, libGL
, wayland, wayland-protocols, libinput, libxkbcommon, pixman, libcap, mesa, xorg
, libpng, ffmpeg_4, hwdata, seatd, vulkan-loader, glslang, nixosTests
, enableXWayland ? true, xwayland ? null }:
stdenv.mkDerivation rec {
  pname = "wlroots14";
  version = "0.14.1";
  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "wlroots";
    repo = "wlroots";
    rev = version;
    hash = "sha256-wauk7TCL/V7fxjOZY77KiPbfydIc9gmOiYFOuum4UOs=";
  };
  # $out for the library and $examples for the example programs (in examples):
  outputs = [ "out" "examples" ];
  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner ];
  buildInputs = [
    ffmpeg_4
    libGL
    libcap
    libinput
    libpng
    libxkbcommon
    mesa
    pixman
    seatd
    vulkan-loader
    wayland
    wayland-protocols
    xorg.libX11
    xorg.xcbutilerrors
    xorg.xcbutilimage
    xorg.xcbutilrenderutil
    xorg.xcbutilwm
  ] ++ lib.optional enableXWayland xwayland;
  mesonFlags = lib.optional (!enableXWayland) "-Dxwayland=disabled";
  postFixup = ''
    # Install ALL example programs to $examples:
    # screencopy dmabuf-capture input-inhibitor layer-shell idle-inhibit idle
    # screenshot output-layout multi-pointer rotation tablet touch pointer
    # simple
    mkdir -p $examples/bin
    cd ./examples
    for binary in $(find . -executable -type f -printf '%P\n' | grep -vE '\.so'); do
      cp "$binary" "$examples/bin/wlroots-$binary"
    done
  '';
  # Test via TinyWL (the "minimum viable product" Wayland compositor based on wlroots):
  passthru.tests.tinywl = nixosTests.tinywl;
  meta = with lib; {
    description = "A modular Wayland compositor library";
    longDescription = ''
      Pluggable, composable, unopinionated modules for building a Wayland
      compositor; or about 50,000 lines of code you were going to write anyway.
    '';
    inherit (src.meta) homepage;
    changelog =
      "https://gitlab.freedesktop.org/wlroots/wlroots/-/tags/${version}";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ];
  };
}
