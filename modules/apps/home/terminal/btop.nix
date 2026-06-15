{ pkgs, gpu, ... }:

let
  rocmSmi = pkgs.rocmPackages.rocm-smi;
  btopWithAmdGpu = pkgs.runCommand "btop-with-amd-gpu" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
    mkdir -p $out/bin $out/lib
    ln -s ${rocmSmi}/lib/librocm_smi64.so.1 $out/lib/librocm_smi64.so.6
    makeWrapper ${pkgs.btop}/bin/btop $out/bin/btop \
      --prefix LD_LIBRARY_PATH : "$out/lib:${rocmSmi}/lib"
  '';
in
{
  programs.btop = {
    enable = true;
    package = if gpu == "amd" then btopWithAmdGpu else pkgs.btop;
    settings = {
      shown_boxes = "cpu mem net proc gpu0";
      show_gpu_info = "On";
    };
  };
}
