#import "../setup-math.typ": *

= Conclusion and Outlook

== Summary

- we established a high-fidelity benchmark for the Maxwell EPGP method, computing the cavity
  reaction operator $amat(T)$ by two methodologically unrelated solvers and comparing them
- on the spherical cavity, where the analytic operator $amat(T)_star$ is available, both the EPGP
  and the BEM solver match the ground truth to $approx 10^(-10)$, certifying each independently
- on the ellipsoidal cavity, where no analytic solution exists, the two solvers agree to
  $approx 10^(-8)$; having both been certified on the sphere, this agreement validates both on a
  geometry with no ground truth
- the ellipsoidal residual is set by the finite BEM mesh, not the EPGP: the EPGP operator is itself
  accurate to $approx 10^(-9)$ and still converging, so the cross-validation understates its accuracy
- the agreement of a boundary-integral and a spectral plane-wave method, sharing no numerical
  machinery, is strong evidence that both are correct
- beyond matching the reference, the EPGP satisfies the time-harmonic Maxwell equations exactly by
  construction, needs no surface mesh, and returns a calibrated posterior uncertainty at no extra cost
- the benchmark thus establishes the EPGP as a trustworthy, Maxwell-consistent, uncertainty-aware
  surrogate for the interior cavity reaction operator

== Future Work

=== Spherical Designs and Lebedev Quadrature

- our EPGP draws wavevector directions from a Fibonacci sphere (quasi-Monte Carlo, convergence
  $tilde N_s^(-1)$); a more principled choice is Lebedev quadrature, which integrates spherical
  harmonics exactly up to a chosen degree and should reach the same kernel accuracy with fewer
  directions, yielding a smaller, better-conditioned system
- left to future work: replace the Fibonacci sphere with Lebedev nodes and quantify the gain

=== Operator-Learning Perspective

- the reaction operator $amat(T)$ is currently assembled column by column: each transmitter dipole
  is a separate conditioning of the same shared prior, solved independently
- an operator-learning view would instead treat the boundary-data-to-field solution operator
  $cal(S)$ (equivalently $amat(T)$ itself) as the object to learn directly, amortizing across all
  excitations rather than reconstructing each column in isolation
- the EPGP posterior is already a linear map from boundary data to field, so the solution operator
  is implicit in the construction; exposing it as the learned object could yield all columns at once
  together with a structured posterior over the operator
- this connects to the inverse-cavity and linear-sampling literature, where the interior solution
  operator is a central building block, and points toward uncertainty-aware variants of those methods
- left to future work

