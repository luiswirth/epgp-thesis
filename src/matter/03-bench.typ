#import "../setup-math.typ": *

= Benchmark Formulation <sec:bench>


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


== Forward Model

Mapping the transmitter dipole to the incident field and calculating the boundary trace on $partial D$

== Probabilistic Reconstruction

How the EP-GP prior is conditioned on the boundary data

== Receiver Evaluation

Extracting the tangential traces on $Lambda$ to build the deterministic response map


