{ callPackage, rocm }:

{
  v1_3_1 = callPackage ./v1_3_1 {
    inherit (rocm) rocr miopengemm rocsparse hipsparse rocthrust
      rccl rocrand rocblas rocfft rocprim hipcub roctracer rocm-cmake;

    miopen = rocm.miopen-hip;
    hip = rocm.hip;
    comgr = rocm.hcc-comgr;
    openmp = rocm.hcc-openmp;
    hcc = rocm.hcc-unwrapped;
  };


  v1_4_0 = callPackage ./v1_4_0 {
    inherit (rocm) rocr miopengemm rocsparse hipsparse rocthrust
      rccl rocrand rocblas rocfft rocprim hipcub roctracer rocm-cmake;

    miopen = rocm.miopen-hip;
    hip = rocm.hip;
    comgr = rocm.hcc-comgr;
    openmp = rocm.hcc-openmp;
    hcc = rocm.hcc-unwrapped;
  };
}
