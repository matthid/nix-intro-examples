{ do_replace ? false
, replacement_torch ? false
, replacement_torchvision ? false
, replacement_torchaudio ? false
, replacement_python ? false }:
final: prev:
let
  real_python = if do_replace then replacement_python else prev.python311;
  real_torch = if do_replace then replacement_torch else real_python.pkgs.torch-bin;
  real_torchvision = if do_replace then replacement_torchvision else real_python.pkgs.torchvision-bin;
  real_torchaudio = if do_replace then replacement_torchaudio else real_python.pkgs.torchaudio-bin;
  real_python311 = real_python.override {
    packageOverrides = final_: prev_: {
      torch = real_torch;
      torchvision = real_torchvision;
      torchaudio = real_torchaudio;
      pytorch-lightning = prev_.pytorch-lightning.override {
        torch = real_torch;
      };
      tensorboardx = prev_.tensorboardx.override {
        torch = real_torch;
      };
    };
  };
in {
  python311 = real_python311;
  my_python = real_python311;
}
