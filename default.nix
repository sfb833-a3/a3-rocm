let
  sources = import ./nix/sources.nix;
  nixpkgs-unstable = import sources.nixpkgs-unstable {};
  rocm = let
    self = (import sources.rocm) (nixpkgs-unstable // self) nixpkgs-unstable;
    in self;
in {
}
