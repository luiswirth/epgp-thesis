# Cavity Scattering Benchmark: Ehrenpreis–Palamodov Gaussian Process for Maxwell’s Equations versus Boundary Element Method

This repository contains the [Typst](https://typst.app/) source files for
the Semester Thesis of Luis Wirth under the supervision of Prof. Dr.-Ing. Stefan
Kurz, for Computational Science and Engineering (CSE) at ETH Zürich.

For the implementation itself, see
- [maxwellgp](https://github.com/luiswirth/maxwellgp), the Maxwell-constrained EP-GP framework.
- [cavity-epgp](https://github.com/luiswirth/cavity-epgp), the cavity-specific EP-GP solver built on maxwellgp.
- [cavity-bem](https://github.com/luiswirth/cavity-bem), the BEM reference solver for the PEC cavity.
- [cavity-benchmark](https://github.com/luiswirth/cavity-benchmark), the cross-validation and benchmarking harness.

## Building the thesis

Requires [Typst](https://typst.app/). `./build.sh` compiles `out/thesis.pdf`;
`./watch.sh` recompiles on save. `./pull-results.sh` copies the figures and
result CSVs from a `cavity-benchmark` checkout (set `BENCH=/path/to/cavity-benchmark`,
defaults to a sibling directory) into `res/`.

## Reproducing the results

The four code repositories are independent; cross-repo dependencies resolve over
https, so no particular directory layout is required. The benchmark harness can
gather solver outputs from a cluster or from local sibling checkouts. End to end:

1. Clone the four repos (side by side under one directory is convenient but not required).
2. Produce the reaction operators with each solver, either locally
   (`./run_local.sh grid` / `ref` in `cavity-bem` and `cavity-epgp`) or on a
   SLURM cluster (`euler/submit_grid.sh` / `submit_ref.sh`; the Euler-specific
   SLURM settings are flagged at the top of each `run.sbatch`).
3. In `cavity-benchmark`: collect the outputs (`./pull-euler.sh`, or
   `REMOTE=.. ./pull-euler.sh` for local checkouts) and run `uv run make-figures`.
4. In this repo: `./pull-results.sh` then `./build.sh`.
