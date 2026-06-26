#import "../setup-math.typ": *
#import "@preview/cetz:0.4.2"

= Cavity Scattering

We present the interior electromagnetic scattering problem: the governing field equations, the cavity geometry, and the reaction operator that both solvers compute.

== Time-Harmonic Maxwell's Equations

The EPGP from @felix is built on the time-harmonic Maxwell's equations, which we briefly review here.

We start with the source-free Maxwell's equations
$
  curl Ev &= -partial_t Bv
  quad quad
  &&div Dv = 0
  \
  curl Hv &= +partial_t Dv
  quad quad
  &&div Bv = 0
$
together with the constitutive relations in vacuum,
$
  Dv = epsilon Ev
  quad quad
  Bv = mu Hv
$

We choose the time-harmonic ansatz
$
  Ev(xv, t) = Re(Ev(xv) e^(-i omega t))
  \
  Hv(xv, t) = Re(Hv(xv) e^(-i omega t))
$
under which differentiation in time becomes complex multiplication,
$
  partial_t |-> -i omega
$
This yields the time-harmonic Maxwell's equations in the frequency domain,
$
  curl Ev &= +i omega mu Hv
  \
  curl Hv &= -i omega epsilon Ev
$

Eliminating the magnetic field via
$
  Hv = 1/(i omega mu) curl Ev
$
gives the curl--curl equation for the electric field $Ev$
$
  curl curl Ev - k^2 Ev = 0
$
with the wavenumber
$
  k = omega sqrt(epsilon mu) = omega / c
$

This is a Helmholtz-type equation for the electric field, with the curl--curl operator $cal(L) := curl curl - k^2$.

#pagebreak()
== Scattering Problem

The scattering problem of interest is inspired by @cavity.
It is an interior problem in a bounded cavity.

The problem is set up as follows:\
A dipole source $delta_t$ is placed in the interior of a cavity $D$ and acts as a transmitter.
It radiates an analytically-known incident field $Ev^i$. The incident field hits the cavity boundary $partial D$ and is reflected by it, creating an unknown scattered field $Ev^s$. The scattered field is read back by another dipole $delta_r$ acting as the receiver.

The total field is the superposition of the incident and scattered part,
$
  Ev = Ev^i + Ev^s
$
where both parts individually and the sum satisfy the source-free curl--curl equation in the interior away from the source.

The object of study is the mapping from transmitter dipole to the measured response at a receiver dipole.

#align(center)[
  #block(
    stroke: 0.5pt + luma(150),
    inset: 8pt,
    radius: 5pt,
    fill: luma(250),
    [
      #let stage(title, qty, prep, dom) = box(
        width: 6em,
        height: 4.8em,
        stroke: 1pt,
        inset: 5pt,
        radius: 3pt,
        fill: white,
      )[
        #set text(size: 9pt, hyphenate: false)
        #set par(justify: false, leading: 0.5em)
        #set align(center + horizon)
        *#title* \
        $#qty$ #text(size: 8pt)[#prep $#dom$]
      ]
      #let step(op, verb) = box(width: 3.8em)[
        #set align(center)
        #set text(size: 9pt)
        $#op$ \
        $arrow.r.long$ \
        #text(size: 8pt, fill: luma(110))[#verb]
      ]
      #grid(
        columns: 9,
        align: horizon,
        column-gutter: 4pt,

        stage("Transmitter", $delta_t$, "on", $Lambda$),
        step($amat(G)$, "radiate"),
        stage("Incident Field", $Ev^i$, "in", $D$),
        step($pi_t$, "trace"),
        stage("Boundary Data", $avec(h)$, "on", $partial D$),
        step($cal(S)$, "solve"),
        stage("Scattered Field", $Ev^s$, "in", $D$),
        step($pi_t^(Lambda)$, "measure"),
        stage("Receiver", $delta_r$, "on", $Lambda$),
      )
    ],
  )
]

=== Transmitter Dipole and Incident Field

Before introducing oscillating dipoles, we first consider the simpler oscillating monopole.

An oscillating monopole $delta^1 = (zv, q)$ is a charge source $rho(xv, t) = q delta_zv exp(-i omega t)$ at a point $zv in D$, with a charge $q in RR$ that gives its strength. The scalar potential it generates is $q Phi$, where $Phi$ is the free-space fundamental solution
$
  Phi(xv; zv) = 1/(4 pi) exp(i k r)/r
$
of the scalar Helmholtz equation
$
  (-Delta - k^2) Phi(dot; zv) = delta_zv
$
where the potential depends only on the distance $r := norm(rv)$ of the separation vector $rv := xv - zv$. 

An oscillating Hertzian dipole $delta^2 = (zv, pv)$ is a current source $Jv(xv, t) = pv delta_zv exp(-i omega t)$ at a point $zv in D$, together with a polarization $pv in RR^3$ that gives the dipole's orientation and strength.

The electric field $Ev^i$ radiated by a dipole is obtained by applying the curl--curl operator to the Hertz vector potential $Phi pv$
$
  Ev^i (xv; delta) = i/k curl_xv curl_xv (Phi(xv; zv) pv)
$

We can rewrite this expression by factoring out the polarization $pv$ by linearity of the curl--curl operator,
$
  Ev^i (xv; delta) = amat(G)(xv; zv) pv
$

This defines the free-space electric dyadic Green's function $amat(G)$, which is the fundamental solution of the curl--curl operator,
$
  amat(G)(xv; zv) pv := i/k curl_xv curl_xv (Phi(xv; zv) pv)
$

Its explicit form is given by
$
  amat(G)(xv; zv) = i k Phi(xv; zv) [(1 + i/(k r) - 1/(k r)^2) amat(I) - (1 + (3 i)/(k r) - 3/(k r)^2) rn rn^transp]
$
where $rn rn^transp$ is the outer product of the unit separation vector $rn := rv \/ r$ and $amat(I)$ is the $3 times 3$ identity matrix.

Our incident field $Ev^i$ is generated by a dipole source $delta_t = (zv_t, pv_t)$ acting as transmitter.

=== Scattered Field and curl--curl BVP

Our cavity $D subset.eq RR^3$ is a bounded domain.
The incident field $Ev^i$ is reflected by the cavity boundary $partial D$
and creates a scattered field $Ev^s$.

The transmitter dipole thus determines both the incident field $Ev^i (xv; delta_t)$ and the scattered field $Ev^s (xv; delta_t)$. The incident field is known analytically, but the scattered field is unknown and gives rise to a boundary value problem that must be solved.

==== PEC Boundary Condition

The boundary conditions of the BVP are the perfectly electrically conducting (PEC) boundary conditions.
They enforce that the scattered field is the exact reflection of the incident field, such
that the two fields cancel each other exactly on the cavity wall.
Hence the total field $Ev = Ev^i + Ev^s$ satisfies the PEC condition
$
  pi_t Ev = 0 quad "on" partial D
$
or equivalently, the scattered field satisfies the boundary condition
$
  avec(h) := pi_t Ev^s = -pi_t Ev^i quad "on" partial D
$

Here $pi_t$ is the tangential projection trace onto $partial D$ with outward normal $nv$, given by
$
  pi_t Ev := nv times (Ev times nv) = Ev - (Ev dot nv) nv
$

==== Interior BVP

The full BVP is then to find the scattered field $Ev^s: D -> CC^3$ in the interior of the cavity $D$ such that
the curl--curl equation is satisfied in the interior and the PEC boundary condition is satisfied on the wall.
$
  curl curl Ev^s - k^2 Ev^s &= 0 quad "in" D
  \
  pi_t Ev^s &= avec(h) quad "on" partial D
$

This BVP is well-defined only when $k^2$ is not a cavity resonance, i.e. not an eigenvalue of the curl--curl operator. Otherwise the BVP solution operator $cal(S): avec(h) |-> Ev^s$ becomes singular.


=== Receiver Dipole and Measurement

The receiver dipole $delta_r = (zv_r, pv_r)$ measures the scattered field $Ev^s$ at its location $zv_r$. Since its polarization $pv_r$ is tangential to $Lambda$, this reads out the tangential trace $pi_t^Lambda Ev^s$ along $pv_r$, yielding a single complex scalar.

Mathematically this is a linear functional $cal(R): C^oo (D; CC^3) -> CC$ defined as
$
  cal(R)(Ev^s) := pv_r dot pi_t^Lambda Ev^s (zv_r; delta_t) = pv_r dot Ev^s (zv_r; delta_t)
$


==== Reciprocity

There are two dipoles, one transmitter and one receiver.
Their roles are complementary: the transmitter generates the incident field, and the receiver measures the scattered field.

The measured response generated by a transmitter dipole $delta_t$ and measured by a receiver dipole $delta_r$ is
$
  r(delta_t, delta_r) = cal(R)(Ev^s) = pv_r dot Ev^s (zv_r; delta_t)
$

Exchanging the two roles leaves the measured response unchanged. This is the Lorentz (Rayleigh--Carson) reciprocity property, a consequence of the symmetry of the curl--curl Green's operator,
$
  r(delta_t, delta_r) = r(delta_r, delta_t)
$


=== Reaction Operator

#text(size: 20pt)[
TODO: REWRITE THIS SECTION!
first introduce the operator in the continuous setting, then discretize it to a matrix!!!
]

So far we have considered a single transmit-receive dipole pair. We now extend to an ensemble of $N_Lambda$ dipoles.

By reciprocity there is no need to distinguish between transmitters and receivers, so the same set of dipoles serves both roles. Every dipole acts as both transmitter and receiver.

Each dipole $delta_i$ acts as a transmitter and generates an incident field $Ev^i (xv; delta_i)$, which gives rise to a scattered field $Ev^s (xv; delta_i)$. This scattered field is measured by every dipole $delta_j$, giving a response $r(delta_j, delta_i)$.

Each such pair $(delta_i, delta_j)$ gives one measured number; these are collected into the reaction operator $T$ with entries
$
  amat(T)_(i j) = r(delta_j, delta_i)
$

Reciprocity implies that the operator is complex-symmetric, not Hermitian,
$
  amat(T)_(i j) = amat(T)_(j i)
  quad ==> quad
  amat(T) = amat(T)^transp
$

The construction is cleanest stated without a basis first. We restrict the dipoles to a common surface $Lambda subset.eq D$, with locations $zv in Lambda$ and polarizations $pv in T_zv Lambda$ tangent to it. A continuous excitation is then a tangential dipole density on $Lambda$, a tangential vector field $avec(g): Lambda -> T Lambda$. It excites a scattered field whose tangential trace $pi_t^Lambda Ev^s$ on $Lambda$ is again a tangential vector field. The continuous reaction operator
$
  cal(T): avec(g) |-> pi_t^Lambda Ev^s [avec(g)]|_Lambda
$
thus maps the space of tangential vector fields on $Lambda$ to itself, and is symmetric by reciprocity.

Our matrix $amat(T)$ is a discretization of $cal(T)$. We sample $N_Lambda$ points $zv_n in Lambda$ and equip each with an orthonormal tangent basis $e_1(zv_n), e_2(zv_n)$ spanning $T_(zv_n) Lambda$, chosen smooth over the surface. The measurement at a point is the tangent vector $pi_t^Lambda Ev^s (zv_n; delta) in T_(zv_n) Lambda$, whose two components in the basis are the two reactions,
$
  r(delta, delta_(n a)) = e_a (zv_n) dot pi_t^Lambda Ev^s (zv_n; delta)
  quad a in {1, 2}
$
so the basis resolves the full tangent vector,
$
  pi_t^Lambda Ev^s (zv_n; delta) = sum_(a = 1,2) r(delta, delta_(n a)) e_a (zv_n)
$
The point measurement is therefore the tangential trace itself in the polarization frame, $T_(zv_n) Lambda tilde.equiv CC^2$. Sampling all points and both polarizations gives $M = 2 N_Lambda$ degrees of freedom and the square matrix $amat(T) in CC^(M times M)$.

This reaction operator $amat(T)$ is the object of interest for the benchmark. Both methods compute it, and the resulting operators are compared.

== Geometry

We now fix the concrete geometry of our benchmark problem. The geometry is mostly taken from @cavity.

First we fix the wavenumber to be $k = 2$.

The dipole surface $Lambda$ is the unit sphere.
$
  Lambda := { xv in RR^3 mid(:) norm(xv) = 1 } subset.eq D
$

We choose $N_Lambda = 32$ dipole locations ${zv_1, ..., zv_(N_Lambda)}$ using a low-discrepancy quasi-uniform Fibonacci sphere distribution.
Together with the 2 polarizations per point, this gives $M = 2 N_Lambda = 64$ configurations.

There are two cavity geometries: an ellipsoidal cavity and a spherical cavity. The ellipsoidal cavity is the original geometry from @cavity, while the spherical cavity is a new addition that allows for an analytic solution.

#let cavity-canvas(rx, ry) = cetz.canvas(length: 0.6cm, {
  import cetz.draw: *
  circle((0, 0), radius: (rx, ry), stroke: 1pt, fill: luma(200))
  circle((0, 0), radius: 1, stroke: 0.8pt, fill: luma(150))
  content((0, ry + 0.6))[$partial D$]
  content((rx * 0.52, ry * 0.6))[$D$]
  content((0, 0))[$Lambda$]
})

=== Ellipsoidal Cavity

The ellipsoidal cavity is the original geometry from @cavity. It is a smooth, convex, and simply connected domain.

Its boundary $partial D$ is an ellipsoidal surface with semi-axes $avec(a) = (a_1, a_2, a_3) = (4, 4, 6)$.

The interior of the ellipsoid is the domain $D$ in which the interior BVP is solved.
$
  D := { (x_1, x_2, x_3) in RR^3 mid(:) (x_1/a_1)^2 + (x_2/a_2)^2 + (x_3/a_3)^2 < 1 }
$

$Lambda$ is well-separated from $partial D$ with a minimum distance of $d_min = 3$.

#figure(
  cavity-canvas(6, 4),
  caption: [Ellipsoidal cavity cross-section],
)

=== Spherical Cavity

The spherical cavity is a new addition that allows for an analytic solution. It is a smooth, convex, and simply connected domain.

Its boundary $partial D$ is a spherical surface with radius $R = 4$. It's obtained from the ellipsoid by shrinking all semi-axes to the shortest, $a_1 = a_2 = 4$.

The interior of the sphere is the domain $D$ in which the interior BVP is solved.
$
  D := { xv in RR^3 mid(:) norm(xv) < R }, quad R = 4
$

#figure(
  cavity-canvas(4, 4),
  caption: [Spherical cavity cross-section],
)

==== Analytic Solution

Thanks to the spherical symmetry, the interior BVP is separable and hence has a closed form solution.
Therefore both scattered field $Ev^s$ and the reaction operator $amat(T)$ have analytic formulas,
which serve as exact reference solutions to validate both numerical solvers.

We do not re-derive the analytic solution here. We refer to @tai for the full derivation and only record the resulting formulas as used in the code.
Correctness is established empirically: both numerical solvers agree with these formulas to $approx 10^(-10)$ independently, which is strong evidence that the formulas are correct.

The interior fields expand in the regular Hansen multipoles, the TM-type $avec(N)_(l m)$ and the TE-type $avec(M)_(l m)$. On a sphere of radius $r$ their tangential traces reduce to the tangential vector spherical harmonics $avec(Psi)_(l m)$ and $avec(Phi)_(l m)$,
$
  pi_t avec(N)_(l m) = (psi_l'(k r))/(k r) avec(Psi)_(l m)
  wide
  pi_t avec(M)_(l m) = j_l (k r) avec(Phi)_(l m)
$
with the spherical Bessel function $j_l$ and the Riccati--Bessel function $psi_l (x) = x j_l (x)$.

We expand the incident tangential trace on the cavity wall ($r = R$) in these harmonics,
$
  p_(l m) = inner(pi_t Ev^i, avec(Psi)_(l m))_(r = R)
  wide
  q_(l m) = inner(pi_t Ev^i, avec(Phi)_(l m))_(r = R)
$

The scattered field expands in the same multipoles,
$
  Ev^s = sum_(l m) (a_(l m) avec(N)_(l m) + b_(l m) avec(M)_(l m))
$

The PEC condition $pi_t Ev^s = -pi_t Ev^i$ on the cavity wall $partial D$ ($r = R$) fixes the coefficients,
$
  a_(l m) = -(k R)/(psi_l'(k R)) p_(l m)
  wide
  b_(l m) = -1/(j_l (k R)) q_(l m)
$

Evaluating the scattered field on the dipole surface $Lambda$ ($r = r_0$) and taking its tangential trace gives the measured response,
$
  pi_t^Lambda Ev^s|_Lambda
  = -sum_(l m) (
    R/r_0 (psi_l'(k r_0))/(psi_l'(k R)) p_(l m) avec(Psi)_(l m)
    + (j_l (k r_0))/(j_l (k R)) q_(l m) avec(Phi)_(l m)
  )
$

Projecting onto the receiver polarization gives the reference reaction operator,
$
  amat(T)_(i j) = en_(a_i) (zv_(n_i)) dot pi_t^Lambda Ev^s (zv_(n_i); delta_j)
$
