{ dependencies ? import ./dependencies.nix { } }:
let
  pkgs = dependencies.pkgs;
  myProject = import ./project.nix { project_dependencies = dependencies; };
in
pkgs.mkShell {
  buildInputs = [
    pkgs.python3
    myProject
    pkgs.git
    pkgs.curl
    pkgs.linuxPackages.nvidia_x11
    pkgs.ncurses5
  ];
  shellHook = ''
    export CUDA_PATH=${dependencies.cudatoolkit}
    export LD_LIBRARY_PATH=/usr/lib/wsl/lib:${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.ncurses5}/lib
    export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
    export EXTRA_CCFLAGS="-I/usr/include"
  '';
}