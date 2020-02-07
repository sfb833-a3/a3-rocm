let
  sources = import ./nix/sources.nix;
  nixpkgs = import sources.nixpkgs {};
  rocm = let
    self = (import sources.nixos-rocm) (nixpkgs // self) nixpkgs;
    in self;
in with nixpkgs; {
  pytorch = {
    v1_4_0 = python37Packages.callPackage pkgs/pytorch/v1_4_0 {
      inherit (rocm) rocr miopengemm rocsparse hipsparse rocthrust
        rccl rocrand rocblas rocfft rocprim hipcub roctracer rocm-cmake;

      miopen = rocm.miopen-hip;
      hip = rocm.hip;
      comgr = rocm.hcc-comgr;
      openmp = rocm.hcc-openmp;
      hcc = rocm.hcc-unwrapped;
    };
  };
}
