#import "../setup-math.typ": *

= Methods

This chapter describes the two solvers used to compute the cavity reaction operator $amat(T)$.
Both represent the scattered field as a superposition of exact solutions of the interior curl--curl equation, so Maxwell's equations hold by construction and only the PEC boundary condition remains to be enforced.
Beyond this shared structure, the two solvers are numerically independent: they share only the problem setup (cavity geometry, wavenumber, dipole configurations) and none of their internal discretizations.

EPGP is probabilistic, returning a posterior distribution over the solution space. It uses a volume plane-wave superposition ansatz and enforces the boundary condition by conditioning on boundary data at scattered collocation points, with no mesh required. BEM is deterministic, returning a single solution. It discretizes the cavity wall into a surface mesh, represents the field via a boundary single-layer potential, and enforces the boundary condition by solving a boundary integral equation.

== Ehrenpreis--Palamodov Gaussian Process

The Ehrenpreis--Palamodov Gaussian Process (EPGP) is a probabilistic, spectral method. Its ansatz is a superposition of transverse plane waves, which satisfy Maxwell's equations exactly. It places a Gaussian prior on the plane-wave amplitude density and enforces the boundary condition by conditioning on the boundary data, yielding a posterior distribution over the solution space.

=== Fundamental Principle

A linear PDE with constant coefficients takes the form $L uv = 0$, where $L = L[partial_1, dots, partial_n]$ is a matrix-valued polynomial in the partial derivatives. The Fourier transform turns differentiation into multiplication, $partial_j |-> i k_j$, so $L$ acts on plane waves by its symbol,
$
  L (av exp(i kv dot xv)) = P(kv) av exp(i kv dot xv)
$
where $P(kv) := L[i k_1, dots, i k_n]$ is an ordinary matrix polynomial in the wavevector $kv$.
A plane wave is therefore a solution exactly when its amplitude lies in the kernel of the symbol, $P(kv) av = 0$.

The Ehrenpreis--Palamodov fundamental principle reverses this reasoning. It states that _all_ solutions $uv$ of linear PDEs with constant coefficients
can be recovered by an inverse Fourier transform, as a continuous superposition of such plane-wave solutions
$
  uv(xv) = integral_(V) av(kv) exp(i kv dot xv) dif kv
$
with wavevectors $kv$ on the characteristic variety $V$ of the symbol $P$
$
  V = { kv in RR^d mid(:) det P(kv) = 0 }
$
and amplitude densities $av$ in its kernel,
$
  av(kv) in ker P(kv)
$

The variety collects the wavevectors at which the symbol is singular,
and the kernel condition restricts each amplitude to the directions the symbol annihilates.

Rather than carry the kernel constraint, we remove it by projection. Writing $amat(Pi)_kv$ for the orthogonal projector onto $ker P(kv)$, any unconstrained weight $avec(w)(kv)$ yields an admissible amplitude $av(kv) = amat(Pi)_kv avec(w)(kv)$. Folding the projector into a matrix-valued feature map,
$
  amat(Phi)_kv (xv) = amat(Pi)_kv exp(i kv dot xv)
$
every solution becomes a superposition of features with a free weight,
$
  uv(xv) = integral_V amat(Phi)_kv (xv) avec(w)(kv) dif kv
$

==== Time-Harmonic Maxwell's Equations

We specialize to the time-harmonic Maxwell's equations, equivalently the curl--curl Helmholtz equation. Its symbol, with the wavenumber $k$, is
$
  P(kv) = (norm(kv)^2 - k^2) amat(I) - kv kv^transp
$
whose determinant vanishes on a $k$-scaled 2-sphere, the characteristic variety
$
  V_k = { kv in RR^3 mid(:) norm(kv) = k } = k SS^2
$
On the variety the symbol is singular and reduces to a scaled rank-one projector onto the wavevector,
$
  P(kv) = -kv kv^transp
  quad kv in V_k
$
whose kernel is the plane perpendicular to the wavevector,
$
  ker P(kv) = { av in CC^3 mid(:) kv dot av = 0 }
$

 Enforcing Maxwell's equations therefore amounts to a transversality constraint on the amplitude,
$
  av(kv) perp kv
$

The orthogonal projector onto the kernel is the transverse complement of that rank-one projector,
$
  amat(Pi)_kv = amat(I) - (kv kv^transp)/norm(kv)^2
$
The general feature map and EP representation thus specialize to a superposition of transverse plane waves with a free weight,
$
  amat(Phi)_kv (xv) = amat(Pi)_kv exp(i kv dot xv)
  quad
  Ev (xv) = integral_(V_k) amat(Phi)_kv (xv) avec(w)(kv) dif kv
$

=== Gaussian Maxwell Prior

Since the field is linear in the weight, a Gaussian measure on $avec(w)$ makes the field a Gaussian process,
$
  Ev tilde cal(G P)(0, amat(K))
$
with matrix covariance kernel
$
  amat(K)(xv, yv) = integral_(V_k) amat(Phi)_kv (xv) amat(Phi)_kv^herm (yv) dif kv
$
Because the projector sits inside every feature, the prior is supported entirely on the solution space: every sample satisfies Maxwell exactly.

#pagebreak(weak: true)
=== Conditioning and Posterior

We turn the prior into a solver by conditioning on observations of the field.
An observation is a linear functional $cal(R)$ of the field, for instance its value or its tangential trace at a point.
We condition on $N_b$ observations at points $X_b$, collected with their measured values in a data vector $hv$.

After conditioning the posterior is again a Gaussian process
$
  Ev | hv tilde cal(G P)(Ev_star, amat(K)_star)
$
with posterior mean $Ev_star$ and posterior covariance $amat(K)_star$.

We introduce a Tikhonov regularization parameter $sigma_n^2 > 0$.
It trades off fitting the data against trusting the prior: as $sigma_n^2 -> 0$ the posterior mean interpolates the observations exactly, while $sigma_n^2 > 0$ relaxes this to a regression that smooths the fit.

The posterior mean field is the regularized best fit to the data, tempered by the prior and the regularization.
$
  Ev_star (xv) = amat(K)(xv, X_b) (amat(K)_(b b) + sigma_n^2 amat(I))^(-1) hv
$

The posterior covariance is the Schur complement of the conditioning block, measuring how underdetermined the field remains after conditioning.
$
  amat(K)_star (xv, yv) = amat(K)(xv, yv)
  - amat(K)(xv, X_b) (amat(K)_(b b) + sigma_n^2 amat(I))^(-1) amat(K)(X_b, yv)
$

This is exact, infinite-dimensional GP regression: prior and posterior both live on the solution space.

=== Discretization

The posterior of the previous section is exact but not yet computable: the kernel entries are integrals over $V_k$ with no closed form. We discretize the EP integral by quadrature, which both makes the kernel computable and expresses the field through explicit finite features.

==== Finite Spectral Features

We approximate the integral over $V_k$ by a finite sum over $N_s$ spectral directions $kv_j in V_k$, drawn from a Fibonacci sphere, a quasi-uniform low-discrepancy point set.
For each direction we pick an orthonormal basis $av_(j 1), av_(j 2)$ of the transverse plane, recovering the projector as an outer-product sum,
$
  amat(Pi)_(kv_j) = sum_(a = 1)^2 av_(j a) av_(j a)^herm
$
so each spectral direction contributes two scalar plane-wave features $avec(phi)_(j a) (xv) = av_(j a) exp(i kv_j dot xv)$, giving $F = 2 N_s$ features in total. The field becomes a finite superposition with one scalar coefficient per feature,
$
  Ev (xv) = sum_(j = 1)^(N_s) sum_(a = 1)^2 w_(j a) avec(phi)_(j a) (xv)
$

These coefficients carry the prior. Gathering them in $avec(w) in CC^F$, the Gaussian measure becomes a finite complex Gaussian,
$
  avec(w) tilde cal(C N)(0, amat(W))
$
Every feature is a transverse plane wave, so this finite prior is still supported entirely on the solution space.

==== Weight-Space Posterior

The discretized model admits two equivalent posteriors. The function-space view of the previous section conditions through the kernel: it forms the $N_b times N_b$ Gram block $amat(K)_(b b)$ at the observation points and solves against it. The explicit features open a second, weight-space view that solves for the coefficient vector $avec(w)$ directly. The two are the same posterior, and the cheaper one depends on which dimension is smaller.

Evaluating the features at the observation points through $cal(R)$ gives the design matrix $amat(Phi) = amat(Phi)(X_b) in CC^(F times N_b)$, through which the data act on the coefficients. The posterior over the coefficients is again Gaussian, with mean $avec(w)_star$ and precision $amat(A)$,
$
  avec(w)_star = amat(A)^(-1) amat(Phi) hv \/ sigma_n^2
  quad
  amat(A) = amat(W)^(-1) + amat(Phi) amat(Phi)^herm \/ sigma_n^2 in CC^(F times F)
$
The matrix $amat(A)$ is the posterior precision in weight space: the prior precision $amat(W)^(-1)$ regularized by the data contribution $amat(Phi) amat(Phi)^herm \/ sigma_n^2$. The posterior mean field follows by mapping the coefficients back through the features, $Ev_star (xv) = amat(Phi)(xv)^herm avec(w)_star$.

Under the same quadrature, the integral kernel of the prior collapses into a finite feature product carrying the prior weights,
$
  amat(K)(xv, yv) = amat(Phi)(xv)^herm amat(W) amat(Phi)(yv)
$
Substituting this discretized kernel into the function-space mean and applying the Woodbury matrix-inversion lemma reproduces the weight-space mean exactly. The lemma trades the $N_b times N_b$ inverse of the function-space solve for the $F times F$ inverse $amat(A)^(-1)$, so we may solve whichever is smaller. The EP construction makes the feature count $F = 2 N_s$ explicit and often modest, while the boundary value problem conditions on many points. Whenever $F < N_b$ the weight-space solve is the cheaper one, with a cost set by the number of features rather than the number of observations.

==== Hyperparameters

The model has three hyperparameters: the spectral directions $kv_j$, the prior weights $amat(W)$, and the regularization parameter $sigma_n$. In a Gaussian process these can be tuned by maximizing the marginal likelihood of the data, usually by gradient descent on its negative logarithm. We instead fix them on principled grounds. The directions come from the Fibonacci sphere, whose even coverage we prefer to keep. The prior weights are set to $amat(W) = amat(I)$, treating all spectral directions equally. The regularization parameter is held fixed, since its marginal-likelihood optimum is governed by the condition number of the system rather than by the data.

=== Implementation `maxwellgp`

The prior and posterior above are implemented in the `maxwellgp` library @felix (Python/JAX), general and problem-independent.
The observation functional $cal(R)$ is supplied to the library and realized through the feature map. Only $cal(R)$ changes between applications, while the plane-wave features, the prior weights, the directions, and the posterior solve are identical.
We refer to @felix for the full theory.

=== EPGP for Boundary Value Problems

The prior already solves the PDE in the interior, so conditioning turns it into a boundary value problem solver: observing the prescribed boundary trace yields the posterior field consistent with it.
The relevant functional is the tangential trace $cal(R) = pi_t$, evaluated at $N_b$ points on the boundary $partial D$, each carrying its outward unit normal $nn$.

Although the prescribed boundary data is exact, we keep $sigma_n^2 > 0$. The finite feature space cannot represent the trace exactly, and the plane-wave Gram matrix is ill-conditioned, so a small noise acts as a Tikhonov regularizer that stabilizes the solve.

Convergence is governed by two parameters, the number of spectral directions $N_s$ and the number of boundary conditioning points $N_b$.

=== EPGP for Cavity Scattering

The `cavity-epgp` layer specializes the BVP solver to the cavity scattering problem. The cavity enters only through the boundary data, and the prior is unchanged.
Each transmitter dipole sets a scattered-field boundary trace $hv = -pi_t Ev^i$. Conditioning on it at the $N_b$ boundary points enforces the PEC condition and yields the posterior scattered field $Ev^s_star$, whose tangential trace at the receivers fills one column of the reaction operator.

#pagebreak()

The $M = 2 N_Lambda$ transmitters share the same $N_b$ conditioning points and differ only in their boundary values $hv$. The conditioning matrix $amat(A)$ is therefore identical across transmitters, and only the right-hand side changes. We factor $amat(A)$ once and reuse the factorization for all $M$ excitations. The posterior covariance depends only on the conditioning points, not on the boundary values, so it is shared by all transmitters and computed once.




== Boundary Element Method

The boundary element method (BEM) is a deterministic, boundary-integral method @colton @buffa. Its ansatz is a single-layer potential, which satisfies Maxwell's equations exactly. It leaves the surface density unknown and enforces the boundary condition by solving the resulting electric field integral equation, yielding a single solution.

=== Formulation

==== Maxwell Single-Layer Potential

The Maxwell single-layer potential $Psi_"SL"$ is defined as
$
  Psi_"SL": H^(-1/2)(div_Gamma, partial D) -> H(curl, D)
  \
  (Psi_"SL" avec(j))(xv) = i k integral_(partial D) amat(G)(xv; yv) avec(j)(yv) dif s(yv)
$
where $amat(G)$ is the free-space electric dyadic Green's function of the Helmholtz curl--curl equation and $avec(j): partial D -> T (partial D)$ is a tangential boundary density.

The single-layer potential is a solution of the interior curl--curl equation for any density.
$
  curl curl (Psi_"SL" avec(j)) - k^2 (Psi_"SL" avec(j)) = 0 quad "in" D
$

==== Rotated Tangential Trace

There is a more natural trace for BEM, the rotated tangential trace $gamma_times$.
$
  gamma_times avec(u) := nn times avec(u)
$

It differs from the projection tangential trace $pi_t$ by a quarter turn in the tangent plane, $
  gamma_times = nn times pi_t
$

==== Maxwell Single-Layer Operator

The Maxwell single-layer operator $cal(V)$ is obtained by applying the rotated tangential trace $gamma_times$ to the single-layer potential.
$
  cal(V): H^(-1/2)(div_Gamma, partial D) -> H^(-1/2)(curl_Gamma, partial D)
  \
  cal(V) := gamma_times Psi_"SL"
$


==== Electric Field Integral Equation

In the indirect formulation, the electric field is represented by a Maxwell single-layer potential $Psi_"SL"$ with an unknown density $avec(j)$.
$
  Ev = Psi_"SL" avec(j)
$

By taking the rotated tangential trace of both sides,
$
  gamma_times Ev = gamma_times Psi_"SL" avec(j) 
$
we obtain the boundary integral equation for the density,
$
  cal(V) avec(j) = avec(h)_times quad "on" partial D
$
where $avec(h)_times = gamma_times Ev$ is the boundary forcing.


This is an electric field integral equation (EFIE) in indirect single-layer form.
As a first-kind Fredholm integral equation, it is inherently ill-conditioned.


The electric field solution is obtained by applying the single-layer potential to the density, and the BVP solution operator is then
$
  cal(S) = Psi_"SL" cal(V)^(-1)
$

=== BEM for Cavity Scattering

==== PEC Boundary Condition

In the rotated trace the PEC condition reads
$
  gamma_times Ev = gamma_times (Ev^i + Ev^s) = 0
  \
  gamma_times Ev^s = -gamma_times Ev^i
$


==== Scattered Field

The boundary data is
$
  avec(h)_times = -gamma_times Ev^i
$

This gives us the boundary integral equation
$
  cal(V) avec(j) = -gamma_times Ev^i quad "on" partial D
$

The scattered field is then recovered by applying the single-layer potential to the density,
$
  Ev^s = Psi_"SL" avec(j) = cal(S) (-gamma_times Ev^i)
$

==== Measurement

The receiver measurement is obtained by projecting the scattered field onto the polarization of the receiver dipole $delta = (zv, pv)$
$
  r = pv dot (pi_t^Lambda Ev^s) (zv) = pv dot (pi_t^Lambda cal(S) (-gamma_times Ev^i)) (zv)
$

Notice the trace asymmetry: the density is solved against the rotated trace $gamma_times$ on the cavity boundary $partial D$, but the measurement reads the tangential projection trace $pi_t^Lambda$ on the dipole surface $Lambda$.

==== Reaction Operator

Each of the $M = 2 N_Lambda$ transmitter dipoles, two polarizations per point on $Lambda$, generates a different incident field and hence a different right-hand side $avec(h)_times = -gamma_times Ev^i$ of the EFIE.

By using an LU decomposition of the single-layer matrix, we can reuse the expensive factorization for each right-hand side.

Evaluating the resulting scattered field at the receivers and projecting onto the polarization frame fills one column of the reaction operator.


=== Implementation `Bembel`

The formulation is discretized with the `Bembel` library @bembel, described by its authors as:

#quote(block: true, attribution: [@bembel])[
  \[Bembel is\] the C++ library featuring higher order isogeometric Galerkin boundary element
  methods for Laplace, Helmholtz, and Maxwell problems. Bembel is compatible with geometries
  from the Octave NURBS package, and provides an interface to the Eigen template library for
  linear algebra operations. For computational efficiency, it applies an embedded fast
  multipole method tailored to the isogeometric analysis framework and a parallel matrix
  assembly based on OpenMP.
]

==== Geometry

Bembel uses a NURBS boundary representation, where our cavity geometries can be represented exactly. We use a NURBS representation of a sphere and scale it to the cavity semi-axes for both our geometries.

==== Galerkin Discretization

We discretize the EFIE by a Galerkin method, which discretizes the operator equation, not merely the unknown. The density is expanded in a finite basis $avec(phi)_1, dots, avec(phi)_N$,
$
  avec(j) approx sum_(i = 1)^N j_i avec(phi)_i
$
and the EFIE is tested against the same basis. The continuous equation $cal(V) avec(j) = avec(h)_times$ becomes a linear system for the coefficients,
$
  amat(V) jv = bv
  quad
  bv_i = integral_(partial D) avec(phi)_i dot avec(h)_times dif s
$
in which the single-layer operator $cal(V)$ is replaced by its Galerkin matrix $amat(V)$. Its entries are the single-layer bilinear form on pairs of basis functions. Integrating the gradients of the dyadic Green's function by parts onto the basis functions reduces it to a double surface integral over the scalar fundamental solution $Phi$ #hl[(@buffa[Sec. 5])],
$
  amat(V)_(a b) = i k integral_(partial D) integral_(partial D) Phi(xv, yv) (avec(phi)_a (xv) dot avec(phi)_b (yv) - 1/k^2 div_Gamma avec(phi)_a (xv) div_Gamma avec(phi)_b (yv)) dif s(yv) dif s(xv)
$

The surface divergence $div_Gamma avec(phi)$ appears in the bilinear form, so the basis must keep it square-integrable. This requires div-conforming elements, whose normal component is continuous across element edges. Bembel uses div-conforming isogeometric B-splines, the higher-order spline analogue of Raviart--Thomas elements, matching the $H^(-1/2)(div_Gamma, partial D)$ trace space of $cal(V)$.

==== Linear Solver

Bembel provides no preconditioner, such as a Calderón projector, so an iterative solver is unattractive. We rely on direct solves instead.

Furthermore we do not use any matrix compression techniques like fast-multipole or hierarchical matrices, because we need high-fidelity reference solutions to compare with the EPGP solutions.
Hence we assemble the dense matrix and solve it by a direct LU factorization.

==== Time-Harmonic Convention

Bembel uses the opposite time-harmonic convention to ours, $e^(-i k r)$ instead of $e^(+i k r)$.
To reconcile this, we conjugate the Bembel output to restore the $e^(+i k r)$ convention.

==== Refinement and Convergence

Convergence is governed by the polynomial degree $p$ and the refinement level $m$ (mesh width $h$).
For a smooth boundary and smooth solution, $h$-refinement converges algebraically and $p$-refinement geometrically.
The ill-conditioning of the first-kind operator worsens under mesh refinement.

