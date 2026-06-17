#import "../setup-math.typ": *

= Conclusion and Outlook <sec:conclusion>

== Summary

== Future Work

=== Spherical Designs & Lebedev Quadrature

Currently our EPGP relies on initializing
the wavevector directions $kn$ based on
a Fibonacci sphere.
It is a quasi-random/low-discrepancy point set,
which makes the EP-integral quadrature approximation
be a quasi-Monte Carlo technique.

A more principeled choise of quadrature relies
on so called spherical designs.
A particularly suitable one being Lebedev quadrature,
which is the equivalent of Gauss-Legendre quadrature
for spherical domains.
It integrates spherical harmonics exactly up to some degree.


=== Operator Learning perspective

