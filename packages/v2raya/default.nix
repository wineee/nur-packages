{ lib
, fetchFromGitHub
, mkYarnPackage
, fetchYarnDeps
, buildGoModule
, makeWrapper
, v2ray
, v2ray-geoip
, v2ray-domain-list-community
, symlinkJoin
}:
let
  pname = "v2raya";
  version = "1.5.10"; # unstable
  src = fetchFromGitHub {
    owner = "v2rayA";
    repo = "v2rayA";
    rev = "24e42a9fc4b9437c451656c117ea6e7f888e59d4";
    sha256 = "sha256-r27FpYHnGSKHFhlQh8pFYoGqXENtYvGU4cNJ9zs+JJs=";
  };
  web = mkYarnPackage {
    inherit pname version;
    src = "${src}/gui";
    offlineCache = fetchYarnDeps {
      yarnLock = src + "/gui/yarn.lock";
      sha256 = "";
    };
    packageJSON = ./package.json;

    # https://github.com/webpack/webpack/issues/14532
    buildPhase = ''
      export NODE_OPTIONS=--openssl-legacy-provider
      ln -s $src/postcss.config.js postcss.config.js
      OUTPUT_DIR=$out yarn --offline build
    '';
    distPhase = "true";
    dontInstall = true;
    dontFixup = true;
  };
in
buildGoModule {
  inherit pname version;
  src = "${src}/service";
  vendorSha256 = "";
  subPackages = [ "." ];
  nativeBuildInputs = [ makeWrapper ];
  preBuild = ''
    cp -a ${web} server/router/web
  '';
  postInstall = ''
    wrapProgram $out/bin/v2rayA \
      --prefix PATH ":" "${lib.makeBinPath [ v2ray ]}" \
      --prefix XDG_DATA_DIRS ":" ${symlinkJoin {
        name = "assets";
        paths = [ v2ray-geoip v2ray-domain-list-community ];
      }}/share
  '';
  meta = with lib; {
    description = "A Linux web GUI client of Project V which supports V2Ray, Xray, SS, SSR, Trojan and Pingtunnel";
    homepage = "https://github.com/v2rayA/v2rayA";
    mainProgram = "v2rayA";
    license = licenses.agpl3Only;
    # maintainers = with lib.maintainers; [ shanoaice ];
  };
}
