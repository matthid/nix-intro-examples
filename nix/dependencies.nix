{ pkgs ? import <nixpkgs> {
    overlays = [
      (import ./overlay/replace-torch.nix { })
      (import ./overlay/ffmpeg.nix)
    ];
    config = {
      allowUnfree = true;
      cudaSupport = true;
    };
  }
, lib ? pkgs.lib
, my_python ? pkgs.python3
, cudatoolkit ? pkgs.cudaPackages.cudatoolkit
, unstable_pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {
    overlays = [
      (import ./overlay/replace-torch.nix {
          do_replace = true;
          replacement_torch = my_python.pkgs.torch;
          replacement_torchvision = my_python.pkgs.torchvision;
          replacement_torchaudio = my_python.pkgs.torchaudio;
          replacement_python = my_python;
      })
    ];
  }
}:
let
  python_packages = my_python.pkgs;
  unstable_python_packages = unstable_pkgs.my_python.pkgs;
  python_doctr = pkgs.callPackage ./packages/doctr.nix {
    pkgs = pkgs;
    my_python = my_python;
  };
in {
  pkgs = pkgs;
  lib = lib;
  my_python = my_python;
  cudatoolkit = cudatoolkit;
  dependencies = with pkgs; [
    python_packages.numpy
    python_packages.torch-bin
    unstable_python_packages.pytorch-lightning
    python_doctr
    cudatoolkit
  ];
}