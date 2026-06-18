#!/bin/bash
# Copy figures and CSVs from cavity-benchmark into thesis res/.
# Run from the epgp-thesis root.
set -euo pipefail
BENCH=../cavity-benchmark
FIGS=$BENCH/out/figs

cp "$FIGS/bem_ellipse_convergence.svg"  res/
cp "$FIGS/epgp_ellipse_convergence.svg" res/
cp "$FIGS/epgp_sphere_convergence.svg"  res/
cp "$FIGS/epgp_ellipse_field_real.png"  res/
cp "$FIGS/epgp_ellipse_field_lic.png"   res/
cp "$FIGS/epgp_sphere_field_real.png"   res/
cp "$FIGS/epgp_sphere_field_lic.png"    res/

cp "$BENCH/out/epgp/ellipse/results.csv" res/ellipse_epgp_results.csv
cp "$BENCH/out/epgp/sphere/results.csv"  res/sphere_epgp_results.csv
cp "$BENCH/out/bem/ellipse/results.csv"  res/ellipse_bem_results.csv
