{
    project_dependencies ? import ./dependencies.nix {}
}:
let
  pkgs = project_dependencies.pkgs;
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
  buildLayeredImage = pkgs.dockerTools.streamLayeredImage;
  lib = pkgs.lib;
  maxLayers = 2;
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
