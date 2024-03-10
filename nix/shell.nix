{ pkgs ? import <nixpkgs> {} }:
let
  myProject = import ./project.nix { pkgs = pkgs; };
in
pkgs.mkShell {
  buildInputs = [
    pkgs.python3
    myProject
    pkgs.git
    pkgs.curl
  ];
}