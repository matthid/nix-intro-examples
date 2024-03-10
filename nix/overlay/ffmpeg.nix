# https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/libraries/ffmpeg/generic.nix
self: super: {
  ffmpeg = super.ffmpeg.override {
    withDebug = false;
    buildFfplay = false;
    withHeadlessDeps = true;
    withCuda = true;
    withNvdec = true;
    withFontconfig = true;
    withGPL = true;
    withAom = true;
    withAss = true;
    withBluray = true;
    withFdkAac =true;
    withFreetype = true;
    withMp3lame = true;
    withOpencoreAmrnb = true;
    withOpenjpeg = true;
    withOpus = true;
    withSrt = true;
    withTheora = true;
    withVidStab = true;
    withVorbis = true;
    withVpx = true;
    withWebp = true;
    withX264 = true;
    withX265 = true;
    withXvid = true;
    withZmq = true;
    withUnfree = true;
    withNvenc = true;
    buildPostproc = true;
    withSmallDeps = true;
  };
}
