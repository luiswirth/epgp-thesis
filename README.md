# BEM Benchmark of the Ehrenpreis–Palamodov Gaussian Process for Maxwell Cavity Scattering

This repository contains the [Typst](https://typst.app/) source files for
the Semester Thesis of Luis Wirth under the supervision of Prof. Dr.-Ing. Stefan
Kurz, for Computational Science and Engineering (CSE) at ETH Zürich.

For the implementation itself, see
- [maxwellgp](https://github.com/luiswirth/maxwellgp), the Maxwell-constrained EPGP framework.
- [cavity-epgp](https://github.com/luiswirth/cavity-epgp), the cavity-specific EPGP solver built on maxwellgp.
- [cavity-bem](https://github.com/luiswirth/cavity-bem), the BEM reference solver for the PEC cavity.
- [cavity-benchmark](https://github.com/luiswirth/cavity-benchmark), the cross-validation and benchmarking harness.

## Building the thesis

Requires [Typst](https://typst.app/).
- `./build.sh` compiles `out/thesis.pdf`;
- `./watch.sh` recompiles on save. 
