{ pkgs ? import <nixpkgs> { } }:

{
  typora-legacy = pkgs.callPackage ./pkgs/typora-legacy { };
  landrop = pkgs.callPackage ./pkgs/landrop { };
  graphbuilder = pkgs.callPackage ./pkgs/graphbuilder { };
  cmd-markdown = pkgs.callPackage ./pkgs/cmd-markdown { };
  electron-netease-cloud-music = pkgs.callPackage ./pkgs/electron-netease-cloud-music { };
}
