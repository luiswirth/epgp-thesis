#import "../setup.typ": *

= Analytic Solution for Spherical Cavity <sec:sphere>

_DISCLAIMER: This section has not been fully verified._

== Problem Setup

The domain is the ball $norm(rv) < R$ with a perfectly electrically conducting
wall at $r = R$. A dipole source sits at $zv$ on the interior sphere $Lambda$ of
radius $a < R$, and the scattered field is measured back on $Lambda$. We keep
$k$, $R$, and $a$ symbolic. The time convention is $e^(-i omega t)$, with the
fundamental solution
$Phi(xv, zv) = e^(i k norm(xv - zv)) \/ (4 pi norm(xv - zv))$.

== Vector Spherical Harmonics and Hansen Multipoles

The angular basis is vector-valued. From the scalar harmonics $Y_l^m$ build the
three orthonormal vector spherical harmonics
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

The dipole field is $Ev^i = (i \/ k) curl curl (Phi pv)$. Away from the source
$curl curl (Phi pv) = nabla (nabla Phi dot pv) + k^2 Phi pv$, so
$
  Ev^i (xv; zv, pv) = i k (amat(I) + 1 / k^2 nabla nabla) Phi(xv, zv) pv
    = i k amat(G)(xv, zv) pv
$
with $amat(G)$ the free-space dyadic Green's function. Its spherical-wave
expansion places the source point on regular multipoles and the field point on
outgoing ones. For a field point outside the source radius, $r_x > r_z$,
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
the value $j_l (k R)$, the TM coefficient by the derivative $psi_l' (k R)$. Each is
singular at the corresponding cavity resonance: $Gamma_l^"TE"$ blows up at the
zeros of $j_l (k R)$, and $Gamma_l^"TM"$ at the zeros of $psi_l' (k R)$, the
resonant wavenumbers of the empty PEC sphere.

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
This is the closed-form solution: an explicit multipole sum in $j_l, h_l^((1))$ and
their Riccati derivatives, fully computable once $k$, $R$, $a$ are fixed and the
points $xv, zv in Lambda$ are chosen.

=== Consistency Checks

Reciprocity requires the reaction operator to be symmetric under exchange of
transmit and receive, up to the tangential rotation $J$ relating forcing and
measurement. The kernel has the form $sum_l Gamma_l avec(A)_(l m) (xv) times.o
conj(avec(A)_(l m) (zv))$ with the same scalar $Gamma_l$ on both slots and the
same multipole family $avec(A) in {avec(M), avec(N)}$ on each side. Swapping $xv$
and $zv$ and transposing therefore returns the same operator, since $Gamma_l$ is
independent of $m$ and the $m$-sum is real-symmetric through
$conj(Y_l^m) = (-1)^m Y_l^(-m)$.

The no-wall limit $R -> infinity$ must recover free space, where the scattered
field vanishes. The reflection coefficients do not vanish pointwise in $R$ because
a lossless cavity always supports a standing wave; the correct statement uses the
limiting-absorption principle. Giving $k$ a small positive imaginary part, the
outgoing $h_l^((1)) (k R)$ decays exponentially while
$j_l (k R) = (h_l^((1)) + h_l^((2))) \/ 2$ grows through its $h_l^((2))$ part, so
$Gamma_l^"TE", Gamma_l^"TM" -> 0$ and $Ev^s -> 0$.

== Angular Band Limit

The scattered field over the ball of radius $R$ is represented on the regular
multipoles $avec(M)_(l m), avec(N)_(l m)$, whose radial factor is $j_l (k r)$
evaluated up to the outer scale $r = R$. The decisive property of $j_l$ is its
decay in the degree at fixed argument: for $l gt.tilde k r$,
$
  j_l (k r) approx (k r)^l / (2 l + 1)!!
$
which falls off super-exponentially because the double factorial grows
super-exponentially. The multipole content of any field confined to $r <= R$ is
therefore effectively truncated at
$
  L_"max" approx k R
$

The reaction operator inherits the cut-off in sharpened form. For $l gt.tilde k R$
the reflection coefficient and the measurement factor combine, using the
small-argument forms $j_l (x) approx x^l \/ (2 l + 1)!!$ and
$h_l^((1)) (x) approx -i (2 l - 1)!! \/ x^(l + 1)$, into
$
  Gamma_l^"TE" j_l (k a)^2 approx (-i) / ((2 l + 1) k R) (a / R)^(2 l)
$
and likewise for the TM channel. Beyond the band edge $l approx k R$ each operator
entry decays geometrically with ratio $(a \/ R)^2 < 1$, set purely by the radius
ratio of measurement surface to wall.

Counting modes makes the effective dimension explicit. The harmonics up to degree
$L_"max" approx k R$ span a space of dimension
$sum_(l=0)^(k R) (2 l + 1) = (k R + 1)^2 approx (k R)^2$. The vector problem
carries two transverse polarizations per degree, the TE and TM Hansen families,
and transverse fields start at $l = 1$ with no monopole, so the effective
dimension is
$
  dim_"eff" approx 2 (k R)^2
$
