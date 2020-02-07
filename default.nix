let
  sources = import ./nix/sources.nix;
  nixpkgs = import sources.nixpkgs {};
  rocm = let
    self = (import sources.nixos-rocm) (nixpkgs // self) nixpkgs;
    in self;
in with nixpkgs; {
  libtensorflow = callPackage pkgs/libtensorflow {
    inherit (rocm) hcc hcc-unwrapped hip miopen-hip miopengemm
      rocrand rocfft rocblas rocr rccl cxlactivitylogger;
  };

  pytorch = callPackage pkgs/pytorch {
    inherit (python3Packages) callPackage;
    inherit rocm;
  };

  # Pass through unmodified.
  inherit (rocm) tensorflow2-rocm;

  tensorflow-rocm = python37Packages.callPackage pkgs/tensorflow/bin.nix {
	  inherit (rocm) hcc hcc-unwrapped hip miopen-hip miopengemm rocrand
	    rocfft rocblas rocr rccl cxlactivitylogger;
	};
}
