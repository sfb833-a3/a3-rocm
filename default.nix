let
  sources = import ./nix/sources.nix;
  nixpkgs = import sources.nixpkgs {};
  rocm = let
    self = (import sources.nixos-rocm) (nixpkgs // self) nixpkgs;
    in self;
in with nixpkgs; {
  pytorch = callPackage pkgs/pytorch {
    inherit (python3Packages) callPackage;
    inherit rocm;
  };
}
