{
    project_dependencies ? import ./dependencies.nix {}
}:
let
  pkgs = project_dependencies.pkgs;
  docker_layering = (import (fetchTarball {
    # URL of the tarball archive of the specific commit, branch, or tag
    url = "https://github.com/matthid/nix-docker-layering/archive/1.0.0.tar.gz";
    sha256 = "0g5y363m479b0pcyv0vkma5ji3x5w2hhw0n61g2wgqaxzraaddva";
  }) { inherit pkgs; });
  lib = project_dependencies.lib;
  cudatoolkit = project_dependencies.cudatoolkit;
  project = import ./project.nix { project_dependencies = project_dependencies; };
  entrypointScriptPath = ../entrypoint.sh; # Adjust the path as necessary
  entrypointScript = pkgs.runCommand "entrypoint-script" {} ''
    mkdir -p $out/bin
    cp ${entrypointScriptPath} $out/bin/entrypoint
    chmod +x $out/bin/entrypoint
  '';
in import ./docker/buildCudaLayeredImage.nix {
  inherit cudatoolkit;
  buildLayeredImage = docker_layering.streamLayeredImage;
  slurpfileGenerator = docker_layering.generators.equal;
  lib = pkgs.lib;
  maxLayers = 20;
  name = "project_nix";
  tag = "latest";

  contents = [
    pkgs.coreutils
    pkgs.findutils
    pkgs.gnugrep
    pkgs.gnused
    pkgs.gawk
    pkgs.bashInteractive
    pkgs.which
    pkgs.file
    pkgs.binutils
    pkgs.diffutils
    pkgs.less
    pkgs.gzip
    pkgs.btar
    pkgs.nano
    (pkgs.python311.withPackages (ps: [
      project
    ]))
    entrypointScript
  ];
  config = {
    Entrypoint = ["${entrypointScript}/bin/entrypoint"];
  };
}
