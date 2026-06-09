#import "../setup-math.typ": *

= Mathematical Background <sec:math>

== Time-Harmonic Maxwell's Equations

Electromagnetism is governed by Maxwell's equations, which in vacuum read
$
  curl Ev = -partial_t avec(B) quad quad & div avec(D) = rho \
  curl Hvec = avec(J) + partial_t avec(D) quad quad & div avec(B) = 0
$
closed by the constitutive relations
$
  avec(D) = epsilon_0 Ev quad quad avec(B) = mu_0 Hvec
$

We pass to time-harmonic fields of angular frequency $omega$ under the
$e^(-i omega t)$ convention, so that $partial_t$ acts as $-i omega$. In a
source-free region the two curl equations become
$
  curl Ev = i omega mu_0 Hvec quad quad curl Hvec = -i omega epsilon_0 Ev
$
Eliminating the magnetic field by taking the curl of the first equation yields
the time-harmonic curl--curl equation
$
  curl curl Ev - k^2 Ev = 0 quad quad k := omega sqrt(epsilon_0 mu_0) = omega / c
$ <eq:curlcurl>

The electric field is divergence-free, $div Ev = 0$. The identity
$
  curl curl = grad div - Delta
$
then reduces the curl--curl equation to the vector Helmholtz equation
$
  Delta Ev + k^2 Ev = 0
$
so each Cartesian component solves the scalar Helmholtz equation, the starting
point for the plane-wave representations of later sections.

On a perfectly electrically conducting wall the tangential electric field
vanishes,
$
  nv_(partial D) times Ev = 0 quad "on" partial D
$ <eq:pec>

== Fundamental Solution

The free-space response to a point source is the fundamental solution of the
Helmholtz operator,
$
  Phi(xv, zv) = 1/(4 pi) exp(i k norm(xv - zv))/norm(xv - zv)
$
which satisfies $(-Delta - k^2) Phi(dot, zv) = delta_zv$ together with the
outgoing condition at infinity.

The electric field radiated by a point dipole at $zv$ with polarization vector
$pv$ follows by applying the dyadic curl--curl operator,
$
  Ev^i (xv; zv, pv) = i/k curl_xv curl_xv (Phi(xv, zv) pv)
$
which solves the time-harmonic curl--curl equation away from the source. We work
throughout with this free-space fundamental solution. The boundary-adapted
Green's function of the cavity, which would itself satisfy the conducting-wall
condition, is a distinct object that we never form explicitly.

== Reaction-Field Problem

Let $D subset.eq RR^3$ be a bounded cavity with perfectly electrically conducting
boundary $partial D$, and let $Lambda subset.eq D$ be an interior surface on which
the sources and measurements are placed. A dipole at a point $zv in Lambda$
radiates the incident field $Ev^i$ above.

Its tangential trace on the wall induces the boundary forcing
$
  avec(h) = -nv_(partial D) times Ev^i quad "on" partial D
$
The scattered field $Ev^s: D -> CC^3$ is the response that restores the
conducting-wall condition, and satisfies the interior curl--curl problem
$
  curl curl Ev^s - k^2 Ev^s &= 0 quad "in" D \
  nv_(partial D) times Ev^s &= avec(h) quad "on" partial D
$
The total field is $Ev = Ev^i + Ev^s$, and the boundary condition above is
exactly the statement that its tangential trace vanishes on the wall,
$nv_(partial D) times Ev = 0$.

=== Tangential Traces

Two traces of a field on a surface enter the formulation: the tangential
projection $Pi_t avec(u) = nv times (avec(u) times nv)$ and the rotated
tangential trace $J avec(u) = nv times avec(u)$. The rotation $J$ acts as a
quarter turn in the tangent plane and satisfies $J^2 = -Pi_t$, so it equips the
tangential fields with a complex structure. The boundary forcing and the
measurement are both rotated traces, which is why they are related through $J$.

The measured data is the tangential trace of the scattered field on the interior
surface $Lambda$,
$
  yv(xv) = nv_Lambda (xv) times Ev^s (xv) quad quad xv in Lambda
$
where $nv_Lambda$ is the unit normal on $Lambda$. Collecting these responses over
all dipole excitations defines the reaction operator, the central object of the
benchmark.

== Characteristic Variety and Plane Waves

The field equations have constant coefficients, so the Fourier transform turns
them into algebra. Writing the transform of a field as
$hat(Ev)(xiv) = integral Ev(xv) e^(-i xiv dot xv) dif xv$, each spatial
derivative becomes multiplication by the frequency variable, so that
$curl |-> i xiv times$ and $Delta |-> -norm(xiv)^2$.

Each Cartesian component of the electric field solves the scalar Helmholtz
equation. Transforming it leaves an algebraic relation,
$
  (Delta + k^2) u = 0 quad ==> quad (norm(xiv)^2 - k^2) hat(u)(xiv) = 0
$
Off the sphere $norm(xiv) = k$ the prefactor is nonzero and forces
$hat(u) = 0$, so the transform of every solution is supported on
$
  V = {xiv in RR^3 mid(|) norm(xiv) = k} = k SS^2
$
the *characteristic variety* of the Helmholtz operator. The wavenumber is fixed
and only the direction of the wave vector remains free. This sphere is the
time-harmonic slice of a larger object. Keeping the time dependence, the wave
operator $c^(-2) partial_t^2 - Delta$ has as its variety the *light cone*
$norm(xiv) = abs(omega) \/ c$ in space-time frequency, and fixing a single
frequency $omega$ with $k = omega \/ c$ cuts the cone at the sphere $V$.

The vector equation refines which fields these wave vectors may carry.
Transforming the curl--curl equation with $curl |-> i xiv times$ gives
$
  curl curl Ev - k^2 Ev = 0 quad ==> quad (norm(xiv)^2 - k^2) hat(Ev) - xiv (xiv dot hat(Ev)) = 0
$
A nonzero amplitude requires the matrix $(norm(xiv)^2 - k^2) amat(I) - xiv xiv^transp$
to be singular. Its determinant $-k^2 (norm(xiv)^2 - k^2)^2$ vanishes only on the
same sphere $norm(xiv) = k$, so the Maxwell variety coincides with the Helmholtz
one. There the relation collapses to $xiv (xiv dot hat(Ev)) = 0$, that is
$xiv dot hat(Ev) = 0$: admissible amplitudes are transverse to the wave vector.
The longitudinal polarization is excluded, which is the Fourier face of the
divergence-free condition $div Ev = 0$, and each direction on the variety carries
a two-dimensional space of polarizations.

Every solution is therefore built from transverse plane waves
$avec(a) e^(i k kn dot rv)$ with direction $kn in SS^2$ and amplitude
$avec(a) perp kn$. That such waves exhaust the solution space is the content of
the *Ehrenpreis--Palamodov principle*: for a constant-coefficient system
$P(partial) u = 0$ every solution on a convex domain is a superposition
$
  u(xv) = integral_V e^(i xiv dot xv) dif mu(xiv)
$
of exponential modes carried by the characteristic variety
$V = {xiv mid(|) det P(xiv) = 0}$, an inverse Fourier transform of a measure on
$V$. In general the modes are weighted by polynomial multiplier operators that
encode the multiplicity of the variety. For the Helmholtz operator the variety
is the simple sphere, no multiplier is needed, and the principle is the classical
*Herglotz representation*
$
  Ev(rv) = integral_(SS^2) avec(a)(kn) e^(i k kn dot rv) dif kn quad quad avec(a)(kn) perp kn
$
with a tangential amplitude density $avec(a)$ on the direction sphere. The
transversality $avec(a) perp kn$ is precisely the multiplier of the Maxwell
system, selecting the two physical polarizations on the variety. The prior of the
next section is a Gaussian measure placed on exactly this density.

== Ehrenpreis-Palamodov Gaussian Processes

- High-level overview of the EP-GP framework.
- not whole EP theory, but explain how to enfroce homogeneous Maxwell system.
- Details see @felix.

Geometric construction of EP plane-wave Gaussian process priors for Maxwell's
equations.

== Boundary Element Method

Indirect Approach using Maxwell Single-Layer Operator.

