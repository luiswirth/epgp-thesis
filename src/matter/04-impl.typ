#import "../setup-math.typ": *

= Numerical Implementation <sec:impl>

In numerical realization, both transmitter and receiver locations are chosen as
vertices of a triangulation of $Lambda$. For each transmitting dipole indexed
by location and tangential polarization basis, the resulting reaction field is
evaluated at all receiver locations and tested against local tangential basis
vectors. This produces a discrete operator mapping transmit configurations to
receive responses, closely related to the operator structure studied in @cavity.
In the present thesis, this operator is probabilistically reconstructed via the
EP-GP posterior.


== Deterministic Reference Solution

For the deterministic baseline and the generation of reference solutions,
the Boundary Element Method (BEM) library Bembel @bembel was used.

Bembel provides an isogeometric boundary element implementation for
three-dimensional electromagnetic problems and allows efficient solution of the
interior curl--curl equation in smooth geometries.

== Probabilistic Reconstruction

The thesis project took advantage of and extended the software implementation
of the EP-GP framework developed in the context of @felix.

The Gaussian process workflow is structured as follows. First, an EP plane-wave
prior is constructed that enforces the homogeneous source-free Maxwell system
in the cavity $D$. For each selected dipole excitation, the induced boundary
trace $avec(h)$ on $partial D$ is computed from the known incident field. The
GP prior is then conditioned on these boundary values. The resulting posterior
field is subsequently evaluated at the receiver locations on the interior sphere
$Lambda$ according to, where the tangential components are compared with the
deterministic reference solution. In this way, Maxwell physics is enforced
exactly in the interior, while boundary forcing information enters through
conditioning.

This setting has several features that make it particularly suitable for
EP plane-wave GP construction. The reaction field satisfies the homogeneous
curl--curl equation in $D$, which is a direct consequence of the source-free
time-harmonic Maxwell system. The EP prior considered in enforces the full
homogeneous Maxwell system exactly and therefore automatically satisfies the
curl-curl equation. Since the problem is purely interior, no radiation condition
is required. The reaction field is also smooth throughout $D$, making it
well matched to spectral and plane-wave representations.


