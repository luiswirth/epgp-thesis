#import "../setup-math.typ": *

= Benchmark Formulation <sec:bench>

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
          EP-GP \ Posterior \
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

Reaction-field formulation for interior
Maxwell problems in PEC cavities.
homogeneous source-free
time-harmonic
curl-curl problem

The thesis developed such a benchmark based on the reaction-field
formulation introduced by Zeng, Cakoni, and Sun @cavity. The setting is an
interior electromagnetic scattering problem in a perfectly electrically
conducting (PEC) cavity $D subset.eq RR^3$ with smooth boundary $partial D$. In
the reference configuration, Dis chosen as a smooth ellipsoid, while the sources
and measurements are taken on an interior sphere $Lambda subset.eq D$.


STUB. \
The operator we benchmark is a discretization of the near-field operator of
@cavity, $(cal(F) phi)(xv) = integral_Lambda nu(xv) times Ev^s (xv, yv,
phi(yv)) dif s(yv)$, which maps tangential dipole densities on $Lambda$ to the
rotated tangential trace of the scattered field on $Lambda$. Our reaction matrix
$T$ is its discretization in the chosen tangent frame, so the benchmark targets
the same operator that underlies their linear sampling method, not an ad hoc
construction.

Through its connection to the inverse scattering literature on cavities
@cavity, the benchmark is positioned within a well-established research field
rather than being a purely synthetic test case. The interior solution operator
underlying the reconstruction problem constitutes a central building block in
linear sampling methods for cavity identification. Establishing a probabilistic,
Maxwell-consistent surrogate of this operator may therefore serve as a step
towards uncertainty-aware variants of such sampling approaches.


== Domain and Geometry

The interior domain is the ellipsoidal cavity with semi-axes $(4, 4, 6)$
$
  D := { (x_1, x_2, x_3) in RR^3 mid(|) (x_1/4)^2 + (x_2/4)^2 + (x_3/6)^2 < 1 }
$

The transmitter and receiver surface is
$
  Lambda := { xv in RR^3 mid(|) norm(xv) = 1 } subset.eq D
$

We use a wavevector $k=2$.


STUB. \
The interior reaction operator is well-defined only when $k^2$ is not a Maxwell
eigenvalue of the cavity $D$ nor of the interior of $Lambda$. @cavity assume
this but do not verify it for their geometry, and their qualitative
reconstruction tolerates proximity to resonances; our high-fidelity target does
not. We must therefore confirm $k=2$ sits comfortably away from the Maxwell
eigenvalues of both $D$ and $Lambda$. The ellipsoidal cavity is electrically
large with dense interior resonances; the resonance sweep (TODO ref) supports
that $k=2$ is well separated from them.



== Relation to Originating Setup

STUB. \
Cavity geometry, surface $Lambda$, and wavenumber $k$ are inherited from
@cavity; transmitters and receivers coincide on $Lambda$, exploiting the same
reaction-operator reciprocity. We differ in intent and fidelity:
- forward solver: high-fidelity BEM and EP-GP, versus their linear edge-element FEM
- accuracy: relative errors near $10^(-7)$ to $10^(-9)$, versus their roughly $10%$
- goal: a reference forward reaction operator, versus inverse shape reconstruction by linear sampling
- sampling: $32$ quasi-uniform points on $Lambda$, versus their $78$ sphere-mesh vertices


== Reference Solution

No closed-form operator.
We need a numerical reference solution.
The accuracy is established by agreement of two unrelated solvers.

We use the Boundary Element Method (BEM) to compute a reference.
BEMBEL library.

== Forward Model

Mapping the transmitter dipole to the incident field and calculating the boundary trace on $partial D$

== Probabilistic Reconstruction

How the EP-GP prior is conditioned on the boundary data

== Receiver Evaluation

Extracting the tangential traces on $Lambda$ to build the deterministic response map


