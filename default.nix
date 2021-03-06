{
  nixpkgs ? import <nixpkgs> {}
}:

let
  sources = import ./nix/sources.nix;
  rocm = nixpkgs.lib.composeExtensions (import sources.nixos-rocm) (self: super: {
    hip = super.hip.overrideAttrs (attrs: rec {
      patches = attrs.patches or [] ++ [
        # Fixes race condition in hipEventRecord, remove with ROCM 3.0.
        # https://github.com/ROCm-Developer-Tools/HIP/pull/1620
        (nixpkgs.fetchpatch {
          name = "fix-hipEventRecord-race.patch";
          url = "https://patch-diff.githubusercontent.com/raw/ROCm-Developer-Tools/HIP/pull/1620.patch";
          sha256 = "1v81ss1ls6jyg2mfspz6zq8a4ajkz5qfhgfwvqrsaih9rbjy8n76";
        })
      ];
    });

    rocblas-tensile = super.rocblas-tensile.overrideAttrs (attrs: with nixpkgs; rec {
      postPatch = attrs.postPatch +
        lib.optionalString (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "9.2") ''
          sed 's|const Items empty;|const Items empty = {};|' -i Tensile/Source/lib/include/Tensile/EmbeddedData.hpp
        '';
    });
  }) (rocm // nixpkgs) nixpkgs;
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
