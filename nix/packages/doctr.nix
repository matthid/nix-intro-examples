{ pkgs ? import <nixpkgs> {}
, lib ? pkgs.lib
, my_python ? pkgs.python311
, buildPythonPackage ? my_python.pkgs.buildPythonPackage
, fetchFromGitHub ? pkgs.fetchFromGitHub }:

buildPythonPackage rec {
  pname = "doctr";
  version = "0.8.1";  # Update this to the latest release version

  src = fetchFromGitHub {
    owner = "mindee";
    repo = pname;
    rev = "v${version}";
    sha256 = "rlIGq5iHDAEWy1I0sAXVSN2/Jh2ub/xLCLCLLp7+9ik=";  # You can generate this with nix-prefetch-github
  };

  nativeBuildInputs = [ my_python.pkgs.setuptools ];
  propagatedBuildInputs = [ my_python.pkgs.torch ];


  postInstall = let
    libPath = "lib/${my_python.libPrefix}/site-packages";
  in
    ''
      mkdir -p $out/nix-support
      echo "$out/${libPath}" > "$out/nix-support/propagated-build-inputs"
    '';

  doCheck = false;

  meta = with lib; {
    description = "Doctr Python package";
    homepage = https://github.com/mindee/doctr;
    license = licenses.asl20;  # Update as per project's licensing
    maintainers = [ ];  # You need to add your name to the list of Nix maintainers
  };
}
