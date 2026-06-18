#import "../setup-math.typ": *

= Mathematical Background <sec:math>

== Maxwell's Equations

Electromagnetism is governed by Maxwell's equations, which in vacuum read
$
 "Faraday's Law"& quad curl Ev = -partial_t avec(B) quad quad & div avec(D) = rho quad "Gauss' Law" \
 "Ampere-Maxwell Law"& quad curl Hvec = avec(J) + partial_t avec(D) quad quad & div avec(B) = 0 quad "Gauss' Law" \
$
closed by the constitutive relations
$
  avec(D) = epsilon_0 Ev quad quad avec(B) = mu_0 Hvec
$


Or in differential geometry using Faraday 2-form
$
  F = Ev wedge dif t + Bv
$
we can write
$
  dif F = 0
  quad quad
  dif hodge F = J
$

with Dirac operator
$
  Dif F = hodge J
$

== Algebraic Maxwell Equation & Fourier Transform


Algebraic geometry and polynomial rings.

Let $D = (partial_t, partial_x, partial_y, partial_z)$. We can represent the
source-free Maxwell's equations as a matrix differential operator $P(D)$ acting
on the 6-component vectors $u = (Bv, Ev)^transp$:
$
  P(D)u = 0
$

Under the Fourier transform we can work on the polynomial ring $CC[omega, k_x, k_y, k_z]$.
We replace derivatives with polynomial variables $partial_t |-> -i omega$ and $nabla |-> i kv$.
This yields the symobl matrix $P(-i omega, i kv)$:\
... Maxwell in fourier.


Under the Fourier transform on Minkowski space $RR^(1,3)$ with signature $(-,+,+,+)$
$
  &partial_t &&limits(|->)^cal(F) -i omega
  \
  grad = &nabla &&limits(|->)^cal(F) i kv
  \
  curl = &nabla times &&limits(|->)^cal(F) i kv times
  \
  div = &nabla dot &&limits(|->)^cal(F) i kv dot
  \
  Delta = &nabla dot nabla &&limits(|->)^cal(F) i kv dot i kv = -abs(kv)^2
$

The principal symbol is
$
  P(omega, kv) = -omega^2/c^2 + abs(kv)^2
$

The characteristic variety (light 3-cone in 4D) is
$
  Lambda = {(omega, kv) mid(|) abs(kv)^2 = omega^2/c^2}
$

== Maxwell Vector Wave Equation

Take curl of Faraday
$
  curl curl Ev = -partial_t curl avec(B)
  \
  curl curl Ev = -partial_t (mu_0 avec(J) + mu_0 epsilon_0 partial_t Ev)
  \
  (1/c^2 partial_t^2 + curl curl) Ev = -mu_0 partial_t avec(J)
$

Use
$
  curl curl = grad div - Delta
$

Gives master equation
$
  (1/c^2 partial_t^2 + grad div - Delta) Ev = -mu_0 partial_t avec(J)
$

Now use Gauss and arrive at the *Maxwell Wave Equation*
$
  square Ev = (1/c^2 partial_t^2 - Delta) Ev = -grad rho/epsilon_0 - mu_0 partial_t avec(J)
$

== Time-Harmonic Maxwell's Equations

$
  Ev (t, xv) = Ev(x) exp(i omega_0 t)
$

We pass to time-harmonic fields of angular frequency $omega$ under the
$e^(-i omega t)$ convention, so that $partial_t$ acts as $-i omega$. In a
source-free region the two curl equations become
$
  curl Ev = i omega B quad quad curl Hvec = -i omega D
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

Principal symbol
$
  P(kv) = -abs(k)^2 + k_0^2
$

Characteristic Variety (2-Sphere in 3D)
$
  Lambda = {kv | abs(kv)^2 = k_0^2} = k_0 SS^2
$

== Characteristic Variety and Plane Waves

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


== Ehrenpreis--Palamodov Fundamental Principle

- Characteristic Variety
- Inverse Fourier Transform
- Superposition of Plane Waves

$
  exp(i (kv dot xv - omega t))
$

4D Frequency space
$
  (omega, k_x, k_y, k_z)
$

== Ehrenpreis--Palamodov Gaussian Processes

High-level overview of the EP-GP framework.

Replace integral with sum.
- use finite superpositions.
- use quadrature.

Put normal prior on plane wave coefficents.
-> Obtain Gaussian Process


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


== Boundary Element Method

Indirect Approach using Maxwell Single-Layer Operator.

