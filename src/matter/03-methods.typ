#import "../setup-math.typ": *

= Methods <sec:methods>

The reaction operator is computed by two methodologically unrelated solvers that
share only the geometry, the sampling points on $Lambda$, and the wavenumber, and
nothing of their internal discretizations. The EPGP solver is a probabilistic,
spectral plane-wave method; the BEM solver is a deterministic boundary-integral
method that serves as the reference. Their agreement validates both at once.

== EPGP Reconstruction <sec:methods-epgp>

For the time-harmonic curl--curl operator the characteristic variety is the
sphere $Lambda_k = { kv mid(|) abs(kv)^2 = k^2 } = k SS^2$, and every solution is
built from transverse plane waves $avec(a) e^(i k kn dot rv)$ with direction
$kn in SS^2$ and amplitude $avec(a) perp kn$. That such waves exhaust the
solution space is the content of the Ehrenpreis--Palamodov principle: for a
constant-coefficient system $P(partial) u = 0$ every solution on a convex domain
is an inverse Fourier transform of a measure carried by the characteristic
variety. For the Maxwell system this is the Herglotz representation
$
  Ev(rv) = integral_(SS^2) avec(a)(kn) e^(i k kn dot rv) dif kn quad quad avec(a)(kn) perp kn
$
with a tangential amplitude density $avec(a)$ on the direction sphere, the
transversality $avec(a) perp kn$ selecting the two physical polarizations.

The EPGP prior places a Gaussian measure on exactly this density. The integral
is replaced by a finite superposition over $N_s$ spectral directions $kn$ drawn
on a Fibonacci sphere, a quasi-uniform low-discrepancy point set, so the
EP integral becomes a quasi-Monte Carlo quadrature. Putting a normal prior on the
plane-wave coefficients yields a Gaussian process whose every sample satisfies the
homogeneous source-free Maxwell system in $D$ exactly.

The reconstruction proceeds as follows. For each dipole excitation the induced
boundary trace $avec(h)$ on $partial D$ is computed from the known incident field.
The GP prior is conditioned on these boundary values at $N_b$ points, and the
resulting posterior-mean scattered field is evaluated at the receiver locations on
$Lambda$, where its tangential components form the reconstructed reaction matrix.
Maxwell physics is enforced exactly in the interior, while boundary forcing enters
only through conditioning. The setting is well matched to a plane-wave prior: the
reaction field satisfies the homogeneous curl--curl equation, the problem is purely
interior so no radiation condition is required, and the field is smooth throughout
$D$. Convergence is governed by two parameters, the number of spectral directions
$N_s$ and the number of boundary conditioning points $N_b$.

The solver builds on and extends the EPGP software of @felix. The Maxwell-constrained
GP core is provided by the `maxwellgp` library, with the cavity-specific dipole
physics and operator assembly layered on top in `cavity-epgp`.

== BEM Reference Solution <sec:methods-bem>

The deterministic baseline solves the same interior curl--curl problem by a
boundary element method using the isogeometric BEM library Bembel @bembel, which
provides an efficient boundary-integral implementation for three-dimensional
electromagnetic problems on smooth geometries. We use an indirect formulation
based on the Maxwell single-layer operator. The geometry is the only input shared
with the EPGP solver; the same base sphere NURBS mesh is scaled to the prescribed
semi-axes. Convergence is governed by the polynomial degree $p$ and the refinement
level $m$. Because the boundary is analytic, the $h$-refinement converges
algebraically and the $p$-refinement geometrically.

// NOTES (Luis) -- complexity result, methods only, no prose yet.
// Both solvers factor once and reuse across all D operator columns
// (D = 2 * n_points dipole configs, transmit = receive on Lambda).
// So D enters only as lower-order multi-RHS / multi-query terms;
// the dominant factorization cost is independent of D.
//
// BEM (cavity-bem/src/main.cpp): dense, no compression (high-fidelity
//   reference). PartialPivLU of the N x N complex Galerkin matrix, all D
//   RHS solved against the single factorization, field eval to form T.
//     N ~ p^2 4^m surface DOFs.
//   factorization        O(N^3)
//   multi-RHS solve       O(N^2 D)
//   field eval -> T       O(N D^2)
//   memory (dense op)     O(N^2)
//   dominant: O(N^3), unchanged by D.
//
// EPGP (maxwellgp gp.py:_factorize): solved in feature/weight space.
//   F = 2 N_s features, M = 3 N_b boundary trace observations.
//   Gram phi phi^H + Cholesky    O(N_s^2 N_b + N_s^3)
//   mean weights (all columns)   O(N_s N_b D + N_s^2 D)
//   operator + covariance        O(N_s D^2 + N_s^2 D)
//   memory (feature matrix)      O(N_s N_b)
//   dominant: O(N_s^2 N_b) for D < N_s (ref: D ~ 1e2, N_s = 2048).

== Computational Complexity <sec:methods-complexity>

#let bigO(x) = $cal(O)(#x)$

Both solvers factor once and reuse the factorization across all $D$ columns of
the reaction operator, so $D$ enters only as lower-order multi-RHS and
multi-query terms; the dominant factorization cost is independent of $D$.

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
) <tab:complexity>
