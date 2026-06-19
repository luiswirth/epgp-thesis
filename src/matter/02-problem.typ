#import "../setup-math.typ": *

= Problem Formulation <sec:problem>

This chapter defines the benchmark. We state the governing time-harmonic Maxwell
system, construct the reaction operator that is the object of study, and fix the
concrete cavity instance. Only the results needed for the benchmark are given;
the underlying derivations are not reproduced here.

== Time-Harmonic Maxwell Equations <sec:problem-maxwell>

Electromagnetism in vacuum is governed by Maxwell's equations,
$
 curl Ev = -partial_t avec(B) quad quad & div avec(D) = rho \
 curl Hvec = avec(J) + partial_t avec(D) quad quad & div avec(B) = 0
$
closed by the constitutive relations $avec(D) = epsilon_0 Ev$ and
$avec(B) = mu_0 Hvec$.

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
$
The electric field is divergence-free, $div Ev = 0$, so the identity
$curl curl = grad div - Delta$ reduces the curl--curl equation to the vector
Helmholtz equation
$
  Delta Ev + k^2 Ev = 0
$
and each Cartesian component solves the scalar Helmholtz equation. This is the
starting point for the plane-wave representation used by the EPGP solver.

== Dipole Source and Incident Field <sec:problem-dipole>

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

== Reaction Operator <sec:problem-operator>

Let $D subset.eq RR^3$ be a bounded cavity with perfectly electrically conducting
boundary $partial D$, and let $Lambda subset.eq D$ be an interior surface on which
the sources and measurements are placed. A dipole at a point $zv in Lambda$
radiates the incident field $Ev^i$ above. Its tangential trace on the wall
induces the boundary forcing
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

Two traces of a field on a surface enter the formulation: the tangential
projection $Pi_t avec(u) = nv times (avec(u) times nv)$ and the rotated
tangential trace $J avec(u) = nv times avec(u)$. The rotation $J$ acts as a
quarter turn in the tangent plane and satisfies $J^2 = -Pi_t$, so it equips the
tangential fields with a complex structure. The boundary forcing and the
measurement are both rotated traces, which is why they are related through $J$.

The measured data is the rotated tangential trace of the scattered field on the
interior surface $Lambda$,
$
  yv(xv) = nv_Lambda (xv) times Ev^s (xv) quad quad xv in Lambda
$
Collecting these responses over all dipole excitations defines the near-field
reaction operator of @cavity,
$
  (cal(F) phi)(xv) = integral_Lambda nv_Lambda (xv) times Ev^s (xv, yv, phi(yv)) dif s(yv)
$
which maps tangential dipole densities on $Lambda$ to the rotated tangential
trace of the scattered field on $Lambda$. In the numerical realization both
transmitter and receiver locations are taken at the same $32$ quasi-uniform
points on $Lambda$, and each dipole is resolved in a local tangent frame. The
reaction matrix $amat(T)$ is the discretization of $cal(F)$ in this frame, so the
benchmark targets the same operator that underlies the linear sampling method of
@cavity rather than an ad hoc construction.

#align(center)[
  #block(
    stroke: 0.5pt + luma(150),
    inset: 15pt,
    radius: 5pt,
    fill: luma(250),
    [
      #set align(center)
      #grid(
        columns: 5,
        align: horizon,
        column-gutter: 15pt,

        rect(stroke: 1pt, inset: 10pt, radius: 3pt, fill: white)[
          *Transmitter* \
          Dipole $pv$ on $Lambda$
        ],

        [
          #set text(size: 9pt)
          Fundamental \
          Solution \
          $==>$ \
          _Deterministic_
        ],

        rect(stroke: 1pt, inset: 10pt, radius: 3pt, fill: white)[
          *Boundary Trace* \
          $avec(h)$ on $partial D$
        ],

        [
          #set text(size: 9pt)
          EPGP \ Posterior \
          $==>$ \
          _Probabilistic_
        ],

        rect(stroke: 1pt, inset: 10pt, radius: 3pt, fill: white)[
          *Reaction Field* \
          $Ev^s$ in $D$ \
          #v(0.1cm)
          $arrow.b$ \
          #v(0.1cm)
          *Receiver Response* \
          $yv$ on $Lambda$
        ]
      )
    ]
  )
]

== Benchmark Geometry <sec:problem-geometry>

The interior domain is the ellipsoidal cavity with semi-axes $(4, 4, 6)$,
$
  D := { (x_1, x_2, x_3) in RR^3 mid(|) (x_1/4)^2 + (x_2/4)^2 + (x_3/6)^2 < 1 }
$
The transmitter and receiver surface is the interior unit sphere
$
  Lambda := { xv in RR^3 mid(|) norm(xv) = 1 } subset.eq D
$
and the wavenumber is $k = 2$.

The interior reaction operator is well-defined only when $k^2$ is not a Maxwell
eigenvalue of the cavity $D$ nor of the interior of $Lambda$, the standard
assumption for this class of problems @cavity. The same geometry and wavenumber
yield a working numerical reconstruction in @cavity, implicit evidence that
$k = 2$ is non-resonant. The clean convergence of the BEM solver to reciprocity
errors below $10^(-10)$ confirms this empirically: a solver near a resonance
would exhibit a severely ill-conditioned system and diverging output, not
monotone high-accuracy convergence.

== Relation to Inverse Scattering <sec:problem-relation>

The benchmark is built on the reaction-field formulation of Zeng, Cakoni, and
Sun @cavity, where the interior solution operator is a central building block in
linear sampling methods for cavity identification. Through this connection the
benchmark sits within an established research field rather than being a purely
synthetic test case, and a probabilistic, Maxwell-consistent surrogate of the
operator may serve as a step toward uncertainty-aware sampling methods.

Cavity geometry, surface $Lambda$, and wavenumber $k$ are inherited from @cavity;
transmitters and receivers coincide on $Lambda$, exploiting the reaction-operator
reciprocity. We differ in intent and fidelity:
- forward solver: high-fidelity BEM and EPGP, versus their linear edge-element FEM
- accuracy: orders of magnitude better than their roughly $10%$ error
- goal: a reference forward reaction operator, versus inverse shape reconstruction by linear sampling
- sampling: $32$ quasi-uniform points on $Lambda$, versus their $78$ sphere-mesh vertices

The ellipsoidal cavity has no closed-form reaction operator, so the EPGP
operator is cross-validated against an independent BEM solve (@sec:res-ellipse).
As a deliberate extension we also treat a spherical cavity, where a closed-form
operator is available and the EPGP is measured against an exact reference
(@sec:res-sphere).
