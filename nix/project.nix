{ pkgs ? import <nixpkgs> {}
, python3Packages ? pkgs.python3Packages }:
let
  project_root = pkgs.lib.cleanSource ../.; # Cleans the parent directory for use
in
python3Packages.buildPythonPackage rec {
  pname = "myproject";
  version = "0.1";

  src = "${project_root}/src";
  pythonPath = [ "${project_root}/src" ];

  propagatedBuildInputs = [
    python3Packages.numpy # Example of a dependency
  ];

  # Disable or enable tests
  doCheck = false; # Set to true to enable test execution
  checkInputs = [ python3Packages.pytest ]; # Dependencies for running tests
  checkPhase = ''
    export PATH=${pkgs.lib.makeBinPath [ python3Packages.pytest ]}:$PATH
    cd ${project_root}/tests
    pytest
  '';
}