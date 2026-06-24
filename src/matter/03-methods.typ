#import "../setup-math.typ": *

= Methods

- compute reaction operator
- two solvers
  - methodologically unrelated
  - same problem setup

- EPGP solver: is a probabilistic, spectral plane-wave method
- BEM solver: deterministic boundary-integral method

== EPGP Solver

- Refer to @felix for full theory.
- GP fulfills source-free time-harmonic maxwell's equations exactly
- probabilistic

time-harmonic curl--curl operator characteristic variety
$
  Lambda_k = { kv mid(|) abs(kv)^2 = k^2 } = k SS^2
$

Ehrenpreis--Palamodov principle:
every solution is infinite superposition of transverse plane waves $avec(a) exp(i kv dot rv)$
with wavevector $kn in k SS^2$ and amplitude $avec(a) perp kv$.
$
  Ev (rv) = integral_(k SS^2) av (kv) exp(i kv dot rv) dif kv
  quad
  av (kv) perp kv
$

- EPGP prior places a Gaussian measure on density $av(kv)$
- Integral approximated by quadrature. -> finite superposition
- finite number $N_s$ spectral directions $kn$
- spectral direction from Fibonacci sphere, a quasi-uniform low-discrepancy point set
- EP integral becomes quasi-Monte Carlo quadrature
- normal prior on plane-wave coefficients
- plane wave prior enforces maxwell in interior.
- GP conditioned on boundary values at $N_b$ points
- boundary forcing through conditioning
- posterior scattered field evaluated (tangential trace) at the receiver locations
- Convergence two parameters: number of spectral directions $N_s$, number of boundary conditioning points $N_b$

cavity-epgp extends maxwellgp for cavity scattering problem.

== BEM Solver

- deterministic baseline
- same interior curl--curl problem
- boundary element method
- isogeometric BEM library Bembel @bembel
- boundary-integral
- for three-dimensional electromagnetic problems on smooth geometries
- indirect formulation
- Maxwell single-layer operator
- sphere NURBS mesh is scaled to semi-axes
- convergence governed by the polynomial degree $p$ and the refinement level $m$
- boundary is smooth -> $h$-refinement converges algebraically, $p$-refinement geometrically
- dense matrix. no H-matrix, no multipole. for high-fidelity
- multiple RHS. Use LU decomp. $D = 2 n_"dipoles"$ RHSs.


== Computational Complexity

#let bigO(x) = $cal(O)(#x)$

- factor once, reuse factorization for each RHS / column of reaction operator

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, center),
    stroke: 0.5pt,
    inset: (x: 8pt, y: 5pt),
    table.header([], [BEM], [EPGP]),
    [factorization], bigO($N^3$),        bigO($N_s^2 N_b + N_s^3$),
    [multi-RHS / mean], bigO($N^2 D$),    bigO($N_s N_b D + N_s^2 D$),
    [operator assembly], bigO($N D^2$),   bigO($N_s D^2 + N_s^2 D$),
    [memory],          bigO($N^2$),       bigO($N_s N_b$),
    table.hline(stroke: 1pt),
    [*dominant*],      bigO($N^3$),       bigO($N_s^2 N_b$),
  ),
  // NOTE prose for later: N ~ p^2 4^m surface DOFs; N_s spectral directions,
  // N_b boundary points; D dipole configurations. EPGP dominant holds for D < N_s.
  caption: [Asymptotic cost of assembling the reaction operator.],
)
