#import "setup.typ": *

= Analytic Solution for Spherical Cavity <sec:sphere>

_DISCLAIMER: This section has not been fully verified._

The ellipsoidal cavity of the benchmark has no closed-form reaction operator. If
the wall is replaced by a perfectly electrically conducting sphere the problem
separates, and the reaction operator is obtained in closed form as a multipole
sum. This appendix carries out that derivation. The spherical cavity is the
exactly solvable model that isolates the mechanism behind the angular band limit
hypothesized in the results chapter.

We keep the wavenumber $k$, the wall radius $R$, and the radius $a$ of the
interior source and measurement surface $Lambda$ symbolic, with $a < R$; the
benchmark uses $a = 1$. The time convention is $e^(-i omega t)$ throughout,
consistent with the fundamental solution
$Phi(xv, zv) = e^(i k norm(xv - zv)) \/ (4 pi norm(xv - zv))$ and the curl--curl
equation of the background chapter.

== Scalar Warm-Up: Interior Dirichlet Problem

Consider first the scalar Helmholtz equation $Delta u + k^2 u = 0$ on the ball
$norm(rv) < R$ with the Dirichlet condition $u = 0$ at $r = R$. Separation of
variables in spherical coordinates factors each mode into a radial part and a
spherical harmonic. The radial equation is the spherical Bessel equation, whose
solution regular at the origin is the spherical Bessel function $j_l$. A field
regular in the interior therefore admits the multipole expansion
$
  u(rv) = sum_(l=0)^infinity sum_(m=-l)^l c_(l m) j_l (k r) Y_l^m (rn)
$
with $r = norm(rv)$ and $rn = rv \/ r$. The irregular solution $y_l$, and with it
the outgoing $h_l^((1)) = j_l + i y_l$, is admitted only in regions excluding the
origin.

A point source at $zv$ with $norm(zv) = a$ is expanded about the cavity centre by
the addition theorem for the free-space Green's function,
$
  Phi(xv, zv) = i k sum_(l=0)^infinity sum_(m=-l)^l
    j_l (k r_<) h_l^((1)) (k r_>) Y_l^m (rn_x) conj(Y_l^m (rn_z))
$
with $r_< = min(norm(xv), norm(zv))$ and $r_> = max(norm(xv), norm(zv))$. The
scattered field is interior-regular, $u^s = sum c^s_(l m) j_l (k r) Y_l^m$.
Evaluating the total field at the wall, where the field point is the outer one so
$r_< = a$ and $r_> = R$, and imposing $u^i + u^s = 0$ mode by mode gives
$
  c^s_(l m) = -i k j_l (k a) (h_l^((1)) (k R)) / (j_l (k R)) conj(Y_l^m (rn_z))
$
The ratio $h_l^((1)) (k R) \/ j_l (k R)$ is the scalar interior reflection
coefficient. It is singular exactly at the zeros of $j_l (k R)$, the Dirichlet
eigenvalues of the ball, and the same structure recurs in the vector problem.

== Vector Spherical Harmonics and Hansen Multipoles

For the Maxwell problem the angular basis is vector-valued. From the scalar
harmonics $Y_l^m$ build the three orthonormal vector spherical harmonics
$
  avec(Y)_(l m) = Y_l^m rn quad quad
  avec(Psi)_(l m) = 1 / sqrt(l(l + 1)) nabla_(SS^2) Y_l^m quad quad
  avec(Phi)_(l m) = rn times avec(Psi)_(l m)
$
where $nabla_(SS^2)$ is the surface gradient. The radial $avec(Y)_(l m)$ is normal
to the sphere; $avec(Psi)_(l m)$ and $avec(Phi)_(l m)$ are tangential and mutually
orthogonal, with $rn times avec(Phi)_(l m) = -avec(Psi)_(l m)$.

The divergence-free solutions of the curl--curl equation regular at the origin are
the regular Hansen multipoles
$
  avec(M)_(l m) (rv) &= j_l (k r) avec(Phi)_(l m) (rn) \
  avec(N)_(l m) (rv) &= sqrt(l(l + 1)) (j_l (k r)) / (k r) Y_l^m (rn) rn
    + (psi_l' (k r)) / (k r) avec(Psi)_(l m) (rn)
$
with the Riccati--Bessel function $psi_l (x) = x j_l (x)$ and
$avec(N)_(l m) = k^(-1) curl avec(M)_(l m)$. The function $avec(M)_(l m)$ is
purely tangential (transverse magnetic field, TE with respect to $rn$);
$avec(N)_(l m)$ carries the radial electric component (TM). Replacing $j_l$ by
$h_l^((1))$, and $psi_l$ by $xi_l (x) = x h_l^((1)) (x)$, gives the outgoing
multipoles $avec(M)^((1))_(l m)$, $avec(N)^((1))_(l m)$, regular away from the
origin.

The two tangential traces on a sphere of radius $r$ follow from the cross-product
relations above,
$
  rn times avec(M)_(l m) &= -j_l (k r) avec(Psi)_(l m) \
  rn times avec(N)_(l m) &= (psi_l' (k r)) / (k r) avec(Phi)_(l m)
$
so the TE trace is controlled by $j_l (k r)$ and the TM trace by the derivative
$psi_l' (k r) = [x j_l (x)]'_(x = k r)$. The radial part of $avec(N)_(l m)$ drops
out of the tangential trace.

== Dipole Field in Multipoles

The dipole field of the background chapter is $Ev^i = (i \/ k) curl curl (Phi pv)$.
Away from the source $curl curl (Phi pv) = nabla (nabla Phi dot pv) + k^2 Phi pv$,
so
$
  Ev^i (xv; zv, pv) = i k (amat(I) + 1 / k^2 nabla nabla) Phi(xv, zv) pv
    = i k amat(G)(xv, zv) pv
$
with $amat(G)$ the free-space dyadic Green's function. Its spherical-wave
expansion places the source point on regular multipoles and the field point on
outgoing ones. For a field point outside the source radius, $r_x > r_z$, the
standard expansion in the normalized basis above reads
$
  amat(G)(xv, zv) = i k sum_(l=1)^infinity sum_(m=-l)^l
    [ avec(M)^((1))_(l m) (xv) conj(avec(M)_(l m) (zv))
    + avec(N)^((1))_(l m) (xv) conj(avec(N)_(l m) (zv)) ]
$
the dyadic outer product contracting against $pv$ in the second slot. The sum
starts at $l = 1$: there is no transverse monopole. Inserting this into the field
gives the incident expansion valid for $a < r_x <= R$,
$
  Ev^i (xv) = -k^2 sum_(l m)
    [ avec(M)^((1))_(l m) (xv) (conj(avec(M)_(l m) (zv)) dot pv)
    + avec(N)^((1))_(l m) (xv) (conj(avec(N)_(l m) (zv)) dot pv) ]
$

The scattered field is interior-regular and expands in the regular multipoles
with unknown coefficients,
$
  Ev^s (xv) = sum_(l m) [ alpha_(l m) avec(M)_(l m) (xv) + beta_(l m) avec(N)_(l m) (xv) ]
$

== Reflection Coefficients from Conducting Wall

The perfectly conducting condition $rn times (Ev^i + Ev^s) = 0$ at $r = R$
separates by tangential vector harmonic. The TE part lives on $avec(Psi)_(l m)$
and the TM part on $avec(Phi)_(l m)$, so the two polarizations decouple. Using the
tangential traces above,
$
  "TE:" quad & alpha_(l m) j_l (k R) - k^2 h_l^((1)) (k R) (conj(avec(M)_(l m) (zv)) dot pv) = 0 \
  "TM:" quad & beta_(l m) (psi_l' (k R)) / (k R) - k^2 (xi_l' (k R)) / (k R) (conj(avec(N)_(l m) (zv)) dot pv) = 0
$
The signs follow from the trace relations, which carry a common $-1$ on the TE row
and a common $+1$ on the TM row. Solving,
$
  alpha_(l m) &= k^2 Gamma_l^"TE" (conj(avec(M)_(l m) (zv)) dot pv) quad quad
    & Gamma_l^"TE" &= (h_l^((1)) (k R)) / (j_l (k R)) \
  beta_(l m) &= k^2 Gamma_l^"TM" (conj(avec(N)_(l m) (zv)) dot pv) quad quad
    & Gamma_l^"TM" &= (xi_l' (k R)) / (psi_l' (k R))
$
These are the interior PEC reflection coefficients. The TE coefficient is fixed by
the value $j_l (k R)$, the TM coefficient by the derivative
$psi_l' (k R) = [x j_l (x)]'_(x = k R)$, exactly the two boundary conditions of an
interior conducting sphere. Each is singular at the corresponding cavity
resonance: $Gamma_l^"TE"$ blows up at the zeros of $j_l (k R)$, and
$Gamma_l^"TM"$ at the zeros of $psi_l' (k R)$. These are the resonant wavenumbers
of the empty PEC sphere, where a source-free interior mode exists and the
steady-state response is undefined.

== Reaction Operator

The measured datum is the tangential trace of the scattered field on $Lambda$,
$yv(xv) = rn times Ev^s (xv)$ at $r = a$. Substituting the scattered expansion and
the trace relations, both source and field point now at radius $a$, gives the
reaction operator as the dyadic kernel mapping a dipole polarization $pv$ at $zv$
to the response $yv$ at $xv$,
$
  amat(T)(xv, zv) = k^2 sum_(l=1)^infinity sum_(m=-l)^l
    [ Gamma_l^"TE" (rn_x times avec(M)_(l m) (xv)) times.o conj(avec(M)_(l m) (zv))
    + Gamma_l^"TM" (rn_x times avec(N)_(l m) (xv)) times.o conj(avec(N)_(l m) (zv)) ]
$
with $yv(xv) = amat(T)(xv, zv) pv$. Written out through the trace relations, the
radial factors are explicit,
$
  amat(T)(xv, zv) = k^2 sum_(l m) [
    & -Gamma_l^"TE" j_l (k a) avec(Psi)_(l m) (rn_x) times.o conj(avec(M)_(l m) (zv)) \
    & + Gamma_l^"TM" (psi_l' (k a)) / (k a) avec(Phi)_(l m) (rn_x) times.o conj(avec(N)_(l m) (zv)) ]
$
This is the closed-form ground truth: an explicit multipole sum in
$j_l, h_l^((1))$ and their Riccati derivatives, fully computable once $k$, $R$,
$a$ are fixed and the points $xv, zv in Lambda$ are chosen.

=== Consistency Checks

Reciprocity requires the reaction operator to be symmetric under exchange of
transmit and receive, up to the tangential rotation $J$ relating forcing and
measurement. The kernel has the form $sum_l Gamma_l avec(A)_(l m) (xv) times.o
conj(avec(A)_(l m) (zv))$ with the same scalar $Gamma_l$ on both slots and the
same multipole family $avec(A) in {avec(M), avec(N)}$ on each side. Swapping $xv$
and $zv$ and transposing therefore returns the same operator, since $Gamma_l$ is
independent of $m$ and the $m$-sum is real-symmetric through
$conj(Y_l^m) = (-1)^m Y_l^(-m)$. The benchmark operator inherits this symmetry,
which is one of the cross-checks satisfied by both numerical solvers.

The no-wall limit $R -> infinity$ must recover free space, where the scattered
field vanishes and the measured reaction is zero. The reflection coefficients do
not vanish pointwise in $R$ because a lossless cavity always supports a standing
wave; the correct statement uses the limiting-absorption principle. Giving $k$ a
small positive imaginary part, the outgoing $h_l^((1)) (k R)$ decays exponentially
while $j_l (k R) = (h_l^((1)) + h_l^((2))) \/ 2$ grows through its $h_l^((2))$
part, so $Gamma_l^"TE", Gamma_l^"TM" -> 0$ and $Ev^s -> 0$. The bounded cavity
collapses to the free-space dipole, as required.

== Angular Band Limit

The payoff is the band limit, here exact rather than heuristic. The scattered
field over the ball of radius $R$ is represented on the regular multipoles
$avec(M)_(l m), avec(N)_(l m)$, whose radial factor is $j_l (k r)$ evaluated up to
the outer scale $r = R$. The decisive property of $j_l$ is its decay in the degree
at fixed argument: for $l gt.tilde k r$,
$
  j_l (k r) approx (k r)^l / (2 l + 1)!!
$
which falls off super-exponentially because the double factorial grows
super-exponentially. The multipole content of any field confined to $r <= R$ is
therefore effectively truncated at
$
  L_"max" approx k R
$
This is the same band limit the results chapter argues for the ellipsoid through
the outer scale of its boundary, obtained here without approximation: the sphere
isolates the mechanism, the radial Bessel cut-off, free of geometry.

The reaction operator inherits the cut-off in sharpened form. For $l gt.tilde k R$
the reflection coefficient and the measurement factor combine, using the
small-argument forms $j_l (x) approx x^l \/ (2 l + 1)!!$ and
$h_l^((1)) (x) approx -i (2 l - 1)!! \/ x^(l + 1)$, into
$
  Gamma_l^"TE" j_l (k a)^2 approx (-i) / ((2 l + 1) k R) (a / R)^(2 l)
$
and likewise for the TM channel. Beyond the band edge $l approx k R$ each operator
entry decays geometrically with ratio $(a \/ R)^2 < 1$, set purely by the radius
ratio of measurement surface to wall. The onset of decay is at $l approx k R$, so
the operator is band-limited at the same degree the field is.

Counting modes makes the effective dimension explicit. The harmonics up to degree
$L_"max" approx k R$ span a space of dimension
$sum_(l=0)^(k R) (2 l + 1) = (k R + 1)^2 approx (k R)^2$. The vector problem
carries two transverse polarizations per degree, the TE and TM Hansen families,
and transverse fields start at $l = 1$ with no monopole, so the effective
dimension is
$
  dim_"eff" approx 2 (k R)^2
$
This is the geometry-free statement of the band-limit hypothesis: the
infinite-dimensional reaction operator of the spherical cavity is, to any fixed
accuracy, a matrix of rank $approx 2 (k R)^2$.
