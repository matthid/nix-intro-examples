{ pkgs ? import <nixpkgs> {
    config = {
      allowUnfree = true;
      cudaSupport = true;
    };
  }
, lib ? pkgs.lib
, my_python ? pkgs.python3
, cudatoolkit ? pkgs.cudaPackages.cudatoolkit
, }:
let
  python_packages = my_python.pkgs;
in {
  pkgs = pkgs;
  lib = lib;
  my_python = my_python;
  cudatoolkit = cudatoolkit;
  dependencies = with pkgs; [
    python_packages.numpy
    python_packages.torch-bin
    cudatoolkit
  ];
}