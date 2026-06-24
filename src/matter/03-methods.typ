#import "../setup-math.typ": *

= Methods

- compute reaction operator
- two solvers
  - methodologically unrelated
  - same problem setup

- EPGP solver: is a probabilistic, spectral plane-wave method
- BEM solver: deterministic boundary-integral method

== Ehrenpreis--Palamodov Gaussian Process

- probabilistic solver: a Gaussian process whose every sample satisfies the
  source-free time-harmonic Maxwell's equations exactly

=== Fundamental Principle

- characteristic variety of the time-harmonic curl--curl operator: the wavevectors
  carried by its plane-wave solutions
$
  V_k = { kv in RR^3 mid(:) norm(kv) = k } = k SS^2
$
- Ehrenpreis--Palamodov fundamental principle: every solution is an infinite
  superposition of transverse plane waves $av exp(i kv dot rv)$, wavevector $kv in V_k$,
  amplitude $av perp kv$
$
  Ev (rv) = integral_(V_k) av (kv) exp(i kv dot rv) dif kv,
  quad
  av (kv) perp kv
$
- the transversality $av perp kv$ is what encodes Maxwell: any such superposition
  solves the curl--curl equation regardless of the amplitude density $av$

=== Gaussian Maxwell Prior

- place a zero-mean circularly-symmetric complex Gaussian measure on the amplitude density
  $av(kv)$ over the variety $V_k$
- transverse plane waves give the matrix-valued feature map, with the transverse projector
  $amat(P)_kv = amat(I) - kn kn^transp$ enforcing $av perp kv$
$
  amat(Phi)_kv (xv) = amat(P)_kv exp(i kv dot xv)
$
- by the integral representation the field is then a Gaussian process $Ev tilde cal(G P)(0, amat(K))$
  on $D$, whose covariance kernel is the EP integral of the feature map
$
  amat(K)(xv, yv) = integral_(V_k) amat(Phi)_kv (xv) amat(Phi)_kv^herm (yv) dif kv
$
- every sample is an EP superposition, so it satisfies Maxwell exactly; the prior lives
  entirely on the solution space, not on arbitrary vector fields

=== Finite Plane-Wave Prior

- approximate the EP integral by quadrature over a finite set of $N_s$ spectral directions
  $kv_j$, drawn from a Fibonacci sphere (quasi-uniform low-discrepancy point set)
- the EP integral becomes a quasi-Monte Carlo sum, with two transverse polarizations per direction
$
  Ev (rv) = sum_(j = 1)^(N_s) sum_(a = 1)^2 w_(j a) av_(j a) exp(i kv_j dot rv),
  quad av_(j a) perp kv_j
$
- the two amplitudes $av_(j 1), av_(j 2)$ are an orthonormal basis of the transverse plane,
  recovering the projector of the continuous feature map
$
  amat(P)_(kv_j) = sum_(a = 1)^2 av_(j a) av_(j a)^herm
$
- each direction and polarization contributes a discrete feature, the sampled plane wave
$
  avec(phi)_(j a) (xv) = av_(j a) exp(i kv_j dot xv)
$
- weights gathered in $avec(w)$, with a circularly-symmetric complex Gaussian prior
  $avec(w) tilde cal(C N)(0, amat(W))$
- the prior covariance is the quasi-Monte Carlo truncation of the continuous kernel
$
  amat(K)(xv, yv) = sum_(j = 1)^(N_s) amat(P)_(kv_j) exp(i kv_j dot (xv - yv))
  = sum_(j = 1)^(N_s) sum_(a = 1)^2 av_(j a) av_(j a)^herm exp(i kv_j dot (xv - yv))
$
- this finite-dimensional weight-space prior still enforces Maxwell in the interior by construction

=== Posterior

- conditioning on data $avec(h)$ at $N_b$ points selects the posterior, the prior samples
  consistent with those values
- collect the plane-wave features at the conditioning points in $amat(Phi)$; the posterior
  mean weights, with noise variance $sigma^2$ and the diagonal prior precision $amat(W)^(-1)$
$
  avec(w)_star = amat(A)^(-1) amat(Phi) avec(h) \/ sigma^2,
  quad amat(A) = amat(W)^(-1) + amat(Phi) amat(Phi)^herm \/ sigma^2
$
- this is the feature-space (weight-space) view: a Gaussian prior on the weights $avec(w)$
  of the explicit plane-wave features, inference solving the $N_s times N_s$ system $amat(A)$
- the equivalent function-space (kernel) view never names features, conditioning instead
  through the kernel $amat(K) = amat(Phi)^herm amat(Phi)$ on an $N_b times N_b$ system
- both give the same posterior; we invert the smaller matrix, and the explicit EP features
  make weight space natural and cheap here, since $N_s < N_b$
- posterior mean field is the feature evaluation $Ev_star (rv) = avec(phi)^herm (rv) avec(w)_star$,
  the same plane-wave features stacked into the columns of $amat(Phi)$
- the posterior covariance is the Schur complement of the conditioning block in the joint prior
  kernel, quantifying the solver's uncertainty
$
  amat(K)_star (xv, yv) = amat(K)(xv, yv)
  - amat(K)(xv, X_b) (amat(K)_(b b) + sigma^2 amat(I))^(-1) amat(K)(X_b, yv)
$
- specializing to a BVP: the prior already solves the PDE in the interior, so conditioning on
  the prescribed boundary traces enforces the boundary condition, turning the prior into a
  BVP solver

=== `maxwellgp`

- the prior and posterior above are implemented in the `maxwellgp` library (Python/JAX),
  general and cavity-independent
- plane-wave feature maps, the GP regression core, and the tangential-trace conditioning
- refer to @felix for the full theory

=== EPGP for Cavity Scattering

- `cavity-epgp` specializes the general `maxwellgp` prior to the cavity scattering problem
- the cavity enters only through the boundary data; the prior is unchanged
- condition on the scattered-field boundary trace $avec(h) = -pi_t Ev^i$ at $N_b$ points on $partial D$,
  which enforces the PEC condition and yields the posterior scattered field $Ev^s_star$
- the tangential trace of the posterior mean at the receivers gives the operator column; entry
  $i j$ is the receiver dipole $delta_i$ reading the field of transmitter $delta_j$
$
  amat(T)_(i j) = pv_i dot pi_t Ev^s_star (zv_i; delta_j)
$
- convergence in two parameters: number of spectral directions $N_s$, number of boundary
  conditioning points $N_b$

=== Computational Cost

#let bigO(x) = $cal(O)(#x)$

- factor once, reuse factorization for each RHS / column of reaction operator
- $N_s$ spectral directions, $N_b$ boundary points, $D = 2 N_Lambda$ dipole configurations
- dominant cost holds for $D < N_s$

#figure(
  table(
    columns: (auto, auto),
    align: (left, center),
    stroke: 0.5pt,
    inset: (x: 8pt, y: 5pt),
    table.header([], [cost]),
    [factorization],     bigO($N_s^2 N_b + N_s^3$),
    [multi-RHS / mean],  bigO($N_s N_b D + N_s^2 D$),
    [operator assembly], bigO($N_s D^2 + N_s^2 D$),
    [memory],            bigO($N_s N_b$),
    table.hline(stroke: 1pt),
    [*dominant*],        bigO($N_s^2 N_b$),
  ),
  caption: [Asymptotic cost of assembling the reaction operator with the EPGP solver.],
)

== Boundary Element Method

- deterministic baseline for the same interior curl--curl problem
- boundary-integral method for three-dimensional electromagnetic problems on smooth geometries

=== Formulation

- indirect formulation: represent the scattered field by a Maxwell single-layer potential
  $Psi_"SL"$ with an unknown tangential density $avec(j)$ on the boundary $partial D$
$
  Ev^s = Psi_"SL" avec(j),
  quad
  (Psi_"SL" avec(j))(xv) = i k integral_(partial D) amat(G)(xv, yv) avec(j)(yv) dif s(yv)
$
- built from the same dyadic Green's function $amat(G)$, so $Ev^s$ solves the interior
  curl--curl equation for any density $avec(j)$
- impose the PEC condition by taking the rotated tangential trace $gamma_times := nv times (dot)$,
  giving a boundary integral equation for the density, with the Maxwell single-layer operator
  $cal(S) := gamma_times Psi_"SL"$
$
  cal(S) avec(j) = -gamma_times Ev^i = -nv times Ev^i quad "on" partial D
$
- the rotated trace, rather than the projection trace $pi_t$ used for the PEC condition,
  gives the symmetric single-layer operator; the condition $nv times Ev = 0$ is equivalent to $pi_t Ev = 0$
- solving for $avec(j)$ and evaluating $Ev^s = Psi_"SL" avec(j)$ recovers the scattered field;
  the inverse $cal(L)^(-1)$ of the interior BVP is realized as $Psi_"SL" cal(S)^(-1)$

=== `Bembel`

- the formulation above is discretized with `Bembel` @bembel, described by its authors as:

#quote(block: true, attribution: [@bembel])[
  \[Bembel is\] the C++ library featuring higher order isogeometric Galerkin boundary element
  methods for Laplace, Helmholtz, and Maxwell problems. Bembel is compatible with geometries
  from the Octave NURBS package, and provides an interface to the Eigen template library for
  linear algebra operations. For computational efficiency, it applies an embedded fast
  multipole method tailored to the isogeometric analysis framework and a parallel matrix
  assembly based on OpenMP.
]

- NURBS boundary representation; the sphere mesh is scaled to the semi-axes
- convergence governed by the polynomial degree $p$ and the refinement level $m$
- boundary is smooth -> $h$-refinement converges algebraically, $p$-refinement geometrically
- `Bembel` offers an embedded fast multipole method, but we assemble the dense matrix
  (no compression) for high fidelity

=== BEM for Cavity Scattering

- each transmitter dipole sets a right-hand side $avec(h) = -pi_t Ev^i$ on $partial D$
- solve $cal(S) avec(j) = avec(h)$ for the density, evaluate $Ev^s = Psi_"SL" avec(j)$,
  measure its tangential trace at the receivers to fill one operator column
- $D = 2 N_Lambda$ dipoles share the single-layer matrix, so factor once and reuse the
  LU factorization across all right-hand sides

=== Computational Cost

- $N tilde p^2 4^m$ surface DOFs, $D = 2 N_Lambda$ dipole configurations / RHSs

#figure(
  table(
    columns: (auto, auto),
    align: (left, center),
    stroke: 0.5pt,
    inset: (x: 8pt, y: 5pt),
    table.header([], [cost]),
    [factorization],     bigO($N^3$),
    [multi-RHS / mean],  bigO($N^2 D$),
    [operator assembly], bigO($N D^2$),
    [memory],            bigO($N^2$),
    table.hline(stroke: 1pt),
    [*dominant*],        bigO($N^3$),
  ),
  caption: [Asymptotic cost of assembling the reaction operator with the BEM solver.],
)
