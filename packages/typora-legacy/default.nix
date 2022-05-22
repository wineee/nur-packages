{ stdenv
, lib
, fetchurl
, makeWrapper
, electron_11
, dpkg
, gtk3
, glib
, gsettings-desktop-schemas
, gdk-pixbuf
, nss
, xorg
, libdrm
, nspr
, alsa-lib
, mesa
, wrapGAppsHook
, autoPatchelfHook
, withPandoc ? true
, pandoc
}:

let
  electron = electron_11;
in
stdenv.mkDerivation rec {
  pname = "typora";
  #version = "0.9.98";
  version = "0.11.0";

  src = fetchurl {
    url = "https://download.typora.io/linux/typora_0.10.3_amd64.deb";
    #sha256 = "sha256-JiqjxT8ZGttrcJrcQmBoGPnRuuYWZ9u2083RxZoLMus=";
    sha256 = "";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    wrapGAppsHook
    autoPatchelfHook
  ];

  buildInputs = [
    glib
    gsettings-desktop-schemas
    gtk3
    xorg.libX11
    xorg.libXext
    xorg.libxcb
    xorg.libxshmfence
    xorg.libXdamage
    nss
    nspr.dev
    gdk-pixbuf
    libdrm
    alsa-lib
    mesa
  ];

  # The deb contains setuid permission on `chrome-sandbox`, which will actually not get installed.
  unpackPhase = "dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner";

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share
    rm -rf usr/share/lintian
    mv usr/* $out

    mv $out/share/typora/resources/app.asar.unpacked/main.node $out/share/typora/resources/

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/typora \
      --add-flags $out/share/typora/resources \
      "''${gappsWrapperArgs[@]}" \
      ${lib.optionalString withPandoc ''--prefix PATH : "${lib.makeBinPath [ pandoc ]}"''} \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ]}"
  '';

  meta = with lib; {
    description = "A minimal Markdown reading & writing app";
    homepage = "https://typora.io";
    license = licenses.unfree;
    maintainers = with maintainers; [ jensbin rewine ];
    platforms = [ "x86_64-linux"];
  };
}
