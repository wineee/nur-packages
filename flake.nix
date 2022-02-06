{
  description = "A very very very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nvfetcher= {
      url = "github:berberman/nvfetcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nvfetcher, flake-utils }: 
    let
      genPkg = f: name: {
        inherit name;
        value = f name;
      };
      pkgDir = ./packages;
      names = with builtins; attrNames (readDir pkgDir);
      withContents = f: with builtins; listToAttrs (map (genPkg f) names);
    in {
      overlay = final: prev:
        withContents (name:
          final.callPackage (pkgDir + "/${name}") {
          
          });
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
          config = {
            allowUnfree = true;
            allowBroken = true;
            allowUnsupportedSystem = true;
          };
        };
      in { packages = withContents (name: pkgs.${name}); });
}
