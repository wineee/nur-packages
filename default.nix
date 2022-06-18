{ pkgs ? import <nixpkgs> { } }:

{
  typora-legacy = pkgs.callPackage ./pkgs/typora-legacy { };
  landrop = pkgs.callPackage ./pkgs/landrop { };
  graphbuilder = pkgs.callPackage ./pkgs/graphbuilder { };
  cmdmarkdown = pkgs.callPackage ./pkgs/cmd-markdown { };
}
