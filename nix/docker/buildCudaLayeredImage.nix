# https://sebastian-staffa.eu/posts/nvidia-docker-with-nix/
# https://github.com/Staff-d/nix-cuda-docker-example
{  cudatoolkit
,  buildLayeredImage
,  lib
,  name
,  tag ? null
,  fromImage ? null
,  contents ? null
,  config ? {Env = [];}
,  extraCommands ? ""
,  maxLayers ? 2
,  fakeRootCommands ? ""
,  enableFakechroot ? false
,  created ? "2024-03-08T00:00:01Z"
,  includeStorePaths ? true
}:

let

  # cut the patch version from the version string
  cutVersion = with lib; versionString:
    builtins.concatStringsSep "."
      (take 3 (builtins.splitVersion versionString )
    );

  cudaVersionString = "CUDA_VERSION=" + (cutVersion cudatoolkit.version);

  cudaEnv = [
    "${cudaVersionString}"
    "NVIDIA_VISIBLE_DEVICES=all"
    "NVIDIA_DRIVER_CAPABILITIES=all"

    "LD_LIBRARY_PATH=/usr/lib64/"
  ];

  cudaConfig = config // {Env = cudaEnv;};

in buildLayeredImage {
  inherit name tag fromImage
    contents extraCommands
    maxLayers
    fakeRootCommands enableFakechroot
    created includeStorePaths;

  config = cudaConfig;
}
