#import "../setup-math.typ": *

= Conclusion and Outlook

== Summary

We established a high-fidelity benchmark for the Maxwell EPGP method. The cavity reaction operator was computed by two methodologically unrelated solvers, a spectral plane-wave EPGP and a boundary-element BEM, and the two were compared.

On the spherical cavity, where the analytic operator is available, BEM matches the ground truth to $approx 3 times 10^(-12)$ and EPGP to $approx 1.3 times 10^(-10)$ #hl[in relative Frobenius-norm error $epsilon$], certifying each independently. On the ellipsoidal cavity, where no analytic solution exists, the two solvers agree to about $10^(-8)$ #hl[in the same relative Frobenius norm]. Since both were already certified on the sphere, this agreement carries over to a geometry with no ground truth. The agreement of a boundary-integral and a spectral plane-wave method, which share no numerical machinery, validates the EPGP on this geometry and certifies the reaction operator as a robust reference benchmark.

Beyond matching the reference, the EPGP satisfies the time-harmonic Maxwell equations exactly by construction, needs no surface mesh, and provides a posterior uncertainty estimate as a byproduct. It is also the cheaper solver at any demanding tolerance, reaching a given reciprocity error two to three orders of magnitude faster than the BEM. The benchmark thus establishes the EPGP as a Maxwell-consistent, uncertainty-aware surrogate for the interior cavity reaction operator.

== Limitations

==== Validation Scope

The validation rests most firmly on the spherical cavity, where each solver is checked directly against the analytic operator. On the ellipsoidal cavity there is no ground truth, so the evidence is the agreement between the two unrelated solvers, which is mutual consistency rather than a direct measure of accuracy. The reciprocity error cannot close this gap, since it constrains only the antisymmetric part of the error.

Both test geometries, and the dipole surface $Lambda$, are fairly symmetric. A defect that appears only on strongly asymmetric domains would therefore not be caught here, though we have no specific reason to expect one.

The benchmark is also confined to a single wavenumber and geometry pair. A wavenumber sweep confirms that $k = 2$ avoids the cavity resonances, but the accuracy itself is validated only at $k = 2$.

==== Cost Comparison

The cost comparison should be read with care. Both solvers ran on identical hardware, but the absolute wall times reflect two particular implementations, a compiled C++ solver and a Python/JAX one, so the runtime factor mixes implementation quality with algorithmic cost. The implementation-independent statement is the asymptotic scaling.

Several factors could shift the comparison in either direction. The EPGP wall time includes the JAX compilation and Python startup, which likely make up its near-constant offset, so timing only the numerical solve would isolate the algorithmic cost. The EPGP also ran on CPU, while JAX can target GPUs, which we did not test and which could lower its cost further. On the other side, the BEM is unoptimized: it uses a dense direct solve with no iterative solver, preconditioner, or matrix compression for fidelity, so a tuned BEM could be considerably faster. The two solvers also parallelize differently, and we did not study how the comparison scales with core count. A fairer comparison, controlling for these factors and counting operations or memory rather than wall time, is left to future work.

==== Uncertainty Quantification

The uncertainty quantification is descriptive and correctly ranks where the field is well or poorly determined by the boundary data, growing in the regions the data constrains least. However what it does not represent is the true reconstruction error. This is because the dominant error comes from truncating the plane-wave expansion at a finite number of spectral features, which is a systematic bias, and a Gaussian variance cannot represent a bias.

The scale of the uncertainty is set by the assumed noise $sigma_n$, so one might try to calibrate it by tuning $sigma_n$ to the data. This does not help. Optimizing $sigma_n$ by maximizing the marginal likelihood drives it toward a floor rather than toward the true error level. The plane-wave features are overcomplete and strongly correlated, so the system's condition number grows like $1\/sigma_n^2$ as the noise decreases. Below a certain noise level the matrix becomes too ill-conditioned to solve stably, and the floating-point floor, rather than the data, determines the smallest usable $sigma_n$.
A more principled quadrature would relieve this.

== Future Work

We see two natural directions to extend this work, one that sharpens the EPGP's spectral discretization and one that changes how the reaction operator is assembled.

==== Spherical Designs and Lebedev Quadrature

The EPGP draws its wavevector directions from a Fibonacci sphere, a quasi-Monte Carlo rule. A more principled choice is Lebedev quadrature #hl[@lebedev], which integrates spherical harmonics exactly up to a chosen degree. It should reach the same kernel accuracy with fewer directions, giving a smaller and better-conditioned system. As noted in the limitations, the lower condition number would also let the assumed noise drop further, which is the main obstacle to calibrated uncertainty.

==== Operator-Learning Perspective

The reaction operator is currently assembled one column at a time. Each transmitter dipole is a separate conditioning of the same shared prior, solved independently. An operator-learning view would instead treat the reaction operator itself as the object to learn directly, producing the whole operator at once instead of rebuilding each column in isolation.
