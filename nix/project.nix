{ project_dependencies ? import ./dependencies.nix { }
, }:
let
  pkgs = project_dependencies.pkgs;
  lib = project_dependencies.lib;
  python_packages = project_dependencies.my_python.pkgs;
  project_root = pkgs.lib.cleanSource ../.; # Cleans the parent directory for use
in
python_packages.buildPythonPackage rec {
  pname = "myproject";
  version = "0.1";

  src = "${project_root}/src";
  pythonPath = [ "${project_root}/src" ];

  propagatedBuildInputs = project_dependencies.dependencies;

  # Disable or enable tests
  doCheck = false; # Set to true to enable test execution
  checkInputs = [ python_packages.pytest ]; # Dependencies for running tests
  checkPhase = ''
    export PATH=${pkgs.lib.makeBinPath [ python_packages.pytest ]}:$PATH
    cd ${project_root}/tests
    pytest
  '';
}