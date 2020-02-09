# A3 ROCm

This repository provides a Nix package set for using the Radeon VII
GPUs in `aion`. It provides the following:

* Pins [nixos-rocm](https://github.com/nixos-rocm/nixos-rocm) to a
  known-good version for `aion`.
* Provides derivations for PyTorch and Tensorflow.
* Pins [nixpkgs](https://github.com/NixOS/nixpkgs) to avoid frequent
  changes and rebuilds.

## Adding the package set

You can add this package set to your Nix configuration and expose it
as an attribute such as `a3-rocm`. In order to do so, add the
following to `~/.config/nixpkgs/config.nix`:

~~~nix
{
  packageOverrides = pkgs: {
    a3-rocm = import (builtins.fetchTarball "https://github.com/sfb833-a3/a3-rocm/archive/master.tar.gz") {};
  };
}
~~~

Then you can use any of the derivations from the package set. E.g.,
to start a shell with PyTorch 1.4.0:

~~~bash
$ nix-shell -p a3-rocm.pytorch.v1_4_0
~~~

## Pinning the package set

The use of `builtins.fetchTarball` above is impure -- the tarball is
always a reflection of the `master` branch of the repository. This has
two downsides: 1. your builds may not be reproducible, something could
change in the repository that breaks your build; and 2. the tarball is
only cached temporarily and will be refetched after a certain amount
of time.

To avoid these problems, you can pin the package set to a particular
revision. E.g.:

~~~nix
{
  packageOverrides = pkgs: {
    a3-rocm = import (builtins.fetchTarball {
        # Get the archive for commit 324dc3
        url = "https://github.com/sfb833-a3/a3-rocm/archive/396a4638dcae31df7b420e37bbf3486925756c98.tar.gz";
        # Get the SHA256 hash using: nix-prefetch-url --unpack <url>
        sha256 = "0zfdbdjrf6l3w1rppyrjq14gqv2ki8ihq2d2hf3ns3aam7lyc5qv";
      }) {};
  };
}
~~~
