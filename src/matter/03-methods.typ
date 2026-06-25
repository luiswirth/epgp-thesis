#import "../setup-math.typ": *

= Methods

- we compute the reaction operator $amat(T)$ by two solvers that are methodologically
  unrelated and share only the problem setup: the same cavity geometry, wavenumber,
  dipole surface, and dipole configurations
- the EPGP solver is a probabilistic, spectral plane-wave method: it places a
  Maxwell-constrained Gaussian prior over the scattered field and conditions it on
  the PEC boundary data
- the BEM solver is a deterministic boundary-integral method: it discretizes the
  single-layer EFIE on the cavity wall and solves for a surface density whose
  potential gives the scattered field
- in both cases the scattered field is represented by an ansatz that already satisfies the
  interior Maxwell system, leaving only the PEC boundary condition to enforce; the solvers
  differ in the ansatz, a volume plane-wave superposition versus a boundary single-layer
  potential, and in how the condition is imposed, by probabilistic conditioning versus a
  deterministic integral-equation solve

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
- each direction and polarization contributes a base plane-wave feature, the field of the
  sampled plane wave
$
  avec(phi)_(j a) (xv) = av_(j a) exp(i kv_j dot xv)
$
- weights gathered in $avec(w) in CC^F$, with $F = 2 N_s$ features (two polarizations per direction),
  and a circularly-symmetric complex Gaussian prior $avec(w) tilde cal(C N)(0, amat(W))$, with diagonal
  $amat(W) in CC^(F times F)$
- the prior covariance is the quasi-Monte Carlo truncation of the continuous kernel, the
  quadrature weights $W_j$ (the diagonal of $amat(W)$) carrying the variety measure
$
  amat(K)(xv, yv) = sum_(j = 1)^(N_s) W_j amat(P)_(kv_j) exp(i kv_j dot (xv - yv))
  = sum_(j = 1)^(N_s) sum_(a = 1)^2 W_j av_(j a) av_(j a)^herm exp(i kv_j dot (xv - yv))
$
- this finite-dimensional weight-space prior still enforces Maxwell in the interior by construction

=== Posterior

- the prior conditions like any Gaussian process: given observations of the field at $N_b$ points,
  the posterior is the prior restricted to the weights consistent with them
- an observation is a linear functional $cal(R)$ of the field, for instance a field value at a point;
  applying it to the base plane-wave features gives the observation features $cal(R) avec(phi)_(j a)$,
  stacked over the conditioning points into the feature matrix $amat(Phi) in CC^(F times D_b)$, where
  $D_b$ is the total data dimension ($3 N_b$ for a tangential trace, $6 N_b$ for the full field)
- conditioning on the data vector $avec(d) in CC^(D_b)$ then yields a Gaussian posterior over the
  weights $avec(w)$
- its mean $avec(w)_star$ is the regularized best-fit: the least-squares fit to the data, regularized
  by the prior and the assumed noise $sigma_"n"^2$
- its covariance $amat(A)^(-1)$ measures how underdetermined the weights remain after conditioning,
  the solver's uncertainty
- the mean weights, with noise variance $sigma_"n"^2$ and the diagonal prior precision $amat(W)^(-1)$, solve
$
  avec(w)_star = amat(A)^(-1) amat(Phi) avec(d) \/ sigma_"n"^2,
  quad amat(A) = amat(W)^(-1) + amat(Phi) amat(Phi)^herm \/ sigma_"n"^2 in CC^(F times F)
$
- this is the feature-space (weight-space) view: a Gaussian prior on the weights $avec(w)$
  of the explicit plane-wave features, inference solving the $F times F$ system $amat(A)$
- the equivalent function-space (kernel) view never names features, conditioning instead
  through the kernel $amat(K) = amat(Phi)^herm amat(W) amat(Phi) in CC^(D_b times D_b)$
- both give the same posterior; we invert the smaller matrix, and the explicit EP features
  make weight space natural and cheap here, since $F < D_b$
- posterior mean field is the feature evaluation $Ev_star (rv) = avec(phi)^herm (rv) avec(w)_star$,
  with the evaluation features $avec(phi)(rv) in CC^(F times 3)$, the same plane-wave features stacked
  into the columns of $amat(Phi)$
- evaluating the features at the receivers propagates the weight covariance $amat(A)^(-1)$ into the
  field; equivalently the posterior covariance is the Schur complement of the conditioning block in
  the joint prior kernel, quantifying the solver's uncertainty
$
  amat(K)_star (xv, yv) = amat(K)(xv, yv)
  - amat(K)(xv, X_b) (amat(K)_(b b) + sigma_"n"^2 amat(I))^(-1) amat(K)(X_b, yv)
$
- specializing to a BVP: the prior already solves the PDE in the interior, so conditioning on
  the prescribed boundary traces enforces the boundary condition, turning the prior into a
  BVP solver

=== `maxwellgp`

- the prior and posterior above are implemented in the `maxwellgp` library (Python/JAX),
  general and cavity-independent
- the observation functional $cal(R)$ is realized by the feature map: either the full
  electromagnetic field $cal(R) = "id"$ (the six $(Ev, Bv)$ components per point) or the tangential
  trace $cal(R) = pi_t$ (the projection $pi_t Ev$, with a boundary normal supplied per conditioning point)
- only $cal(R)$ changes between the two; the base plane-wave features, the prior weights, the
  directions, and the posterior solve are identical
- refer to @felix for the full theory

=== EPGP for Cavity Scattering

- `cavity-epgp` specializes the general `maxwellgp` prior to the cavity scattering problem
- the cavity enters only through the boundary data; the prior is unchanged
- here the observation functional is the tangential trace $cal(R) = pi_t$ and the data is the
  prescribed boundary values: condition on the scattered-field trace $avec(d) = avec(h) = -pi_t Ev^i$
  at $N_b$ points on $partial D$, which enforces the PEC condition and yields the posterior scattered
  field $Ev^s_star$
- the conditioning points are the $N_b$ boundary points on $partial D$, each carrying its outward
  normal $nv$ so that the tangential feature $pi_t$ is defined there
- the tangential trace of the posterior mean at the receivers gives the operator column; entry
  $i j$ is the receiver dipole $delta_i$ reading the field of transmitter $delta_j$
$
  amat(T)_(i j) = pv_i dot pi_t^Lambda Ev^s_star (zv_i; delta_j)
$
- convergence in two parameters: number of spectral directions $N_s$, number of boundary
  conditioning points $N_b$

=== Computational Cost

#let bigO(x) = $cal(O)(#x)$

- factor once, reuse factorization for each RHS / column of reaction operator
- $N_s$ spectral directions, $N_b$ boundary points, $M = 2 N_Lambda$ dipole configurations
- dominant cost holds for $M < N_s$

#figure(
  table(
    columns: (auto, auto),
    align: (left, center),
    stroke: 0.5pt,
    inset: (x: 8pt, y: 5pt),
    table.header([], [cost]),
    [factorization],     bigO($N_s^2 N_b + N_s^3$),
    [multi-RHS / mean],  bigO($N_s N_b M + N_s^2 M$),
    [operator assembly], bigO($N_s M^2 + N_s^2 M$),
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
  $cal(V) := gamma_times Psi_"SL"$ mapping the natural tangential trace spaces
  $cal(V): H^(-1/2)(div_Gamma, partial D) -> H^(-1/2)(curl_Gamma, partial D)$
$
  cal(V) avec(j) = -gamma_times Ev^i = -nv times Ev^i quad "on" partial D
$
- the rotated trace, rather than the projection trace $pi_t$ used for the PEC condition,
  gives the symmetric single-layer operator; the condition $nv times Ev = 0$ is equivalent to $pi_t Ev = 0$
- this is an *electric field integral equation (EFIE)* in indirect single-layer form
- as a first-kind integral operator $cal(V)$ is inherently ill-conditioned, and the
  conditioning worsens under mesh refinement
- solving for $avec(j)$ and evaluating $Ev^s = Psi_"SL" avec(j)$ recovers the scattered field;
  the BVP solution operator $cal(S)$ of the interior problem is realized as $Psi_"SL" cal(V)^(-1)$

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
- the density $avec(j)$ is discretized in div-conforming isogeometric B-spline basis functions
  on the NURBS boundary, the spline analogue of Raviart--Thomas elements, matching the
  $div_Gamma$-conforming trace space of $cal(V)$
- convergence governed by the polynomial degree $p$ and the refinement level $m$
- boundary is smooth -> $h$-refinement converges algebraically, $p$-refinement geometrically
- `Bembel` provides no preconditioner (such as a Calderon projector) for the ill-conditioned
  first-kind system, so an iterative solve is unattractive
- we therefore assemble the dense matrix (no fast-multipole compression) and solve it by a
  direct LU factorization, which also gives high fidelity

- two `Bembel` conventions differ from ours and are reconciled:
  - it uses the opposite convention (outgoing waves carry $e^(-i k r)$), so its scattered field
    comes out conjugated; we conjugate the `Bembel` output to restore our $e^(+i k r)$ convention
  - its symmetric Maxwell single-layer is built on the rotated tangential trace $gamma_times$, the
    trace used in the formulation above

=== BEM for Cavity Scattering

- each transmitter dipole sets the right-hand side $-gamma_times Ev^i = -nv times Ev^i$ on $partial D$
- solve $cal(V) avec(j) = -gamma_times Ev^i$ for the density, evaluate $Ev^s = Psi_"SL" avec(j)$,
  measure its tangential trace at the receivers to fill one operator column
- $M = 2 N_Lambda$ dipoles share the single-layer matrix, so factor once and reuse the
  LU factorization across all right-hand sides

=== Computational Cost

- $N tilde p^2 4^m$ surface DOFs, $M = 2 N_Lambda$ dipole configurations / RHSs

#figure(
  table(
    columns: (auto, auto),
    align: (left, center),
    stroke: 0.5pt,
    inset: (x: 8pt, y: 5pt),
    table.header([], [cost]),
    [factorization],     bigO($N^3$),
    [multi-RHS / mean],  bigO($N^2 M$),
    [operator assembly], bigO($N M^2$),
    [memory],            bigO($N^2$),
    table.hline(stroke: 1pt),
    [*dominant*],        bigO($N^3$),
  ),
  caption: [Asymptotic cost of assembling the reaction operator with the BEM solver.],
)
