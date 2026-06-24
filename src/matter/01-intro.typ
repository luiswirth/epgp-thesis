= Introduction

== Context and Motivation

*Machine learning (ML)* is increasingly used as a tool in the sciences and
engineering, where the systems of interest obey well-established physical laws.
This has given rise to the field of *scientific machine learning (SciML)*, also
known as *AI4Science*. A purely data-driven model ignores the known physical
structure and must rediscover the laws from data alone, which is wasteful and
typically inaccurate outside the regime it was trained on. The more principled
approach embeds established physical knowledge into the model from the outset.
This idea appears under several names, such as *first-principles AI (FPAI)*,
*physics-informed ML* or *hybrid modeling*, which all refer to essentially
the same goal: letting the governing equations constrain the model rather than
learning them from data.

Many physical laws take the form of *partial differential equations (PDEs)*, and
there are two ways to make a model respect such a law. Weak enforcement adds the
PDE residual as a penalty in the training objective, so the constraint is only
satisfied approximately and is traded off against the data; the physics-informed
neural network is the canonical example. *Strong enforcement* instead restricts
the model to functions that satisfy the equation identically by construction, so
the physics holds exactly regardless of the data. Strong enforcement is clearly preferable: the model can then never violate the law it is meant to obey.

Among ML models, the *Gaussian process (GP)* is particularly well suited to
strong enforcement. A GP is a probabilistic model over functions that returns
a full posterior distribution rather than a point estimate. As an added
benefit, *uncertainty quantification* then comes for free: every prediction
carries a calibrated estimate of its own reliability at no extra cost. If
the GP prior is built so that its samples satisfy a PDE exactly, the model is
strongly physics-informed and probabilistic at the same time.

The *Ehrenpreis--Palamodov (EP)* principle provides a constructive route to such
priors for *linear PDEs with constant coefficients* inspired by the *inverse
Fourier transform*. It represents solutions as superpositions of *plane waves*
supported on the *characteristic variety* of the operator. Its GP realization,
the *Ehrenpreis--Palamodov Gaussian Process (EPGP)* @harkonen, builds the
governing equations directly into the prior, so that every sample and every
posterior estimate lies in the solution space of the operator exactly.

A particularly well-understood PDE system is *Maxwell's equations*, which
govern *electromagnetism (EM)*. Building an EPGP for these equations is the
topic of the ongoing effort @felix, which constructs EPGP priors for the
*time-harmonic* Maxwell system from a geometric perspective based on
*differential forms*, the *de Rham complex*, and *Hertz potentials*. This yields
a more geometrically grounded construction than the generic one by @harkonen.

The theoretical framework and a proof-of-concept exist but a convincing
reference benchmark does not. This thesis provides that benchmark.

#pagebreak(weak: true)

== Cavity Benchmark

A useful benchmark for the Maxwell EPGP method should satisfy three
requirements. It should be governed by the time-harmonic Maxwell equations,
it should admit synthetic data generation, and it should be well matched to an
plane-wave prior, meaning a purely interior problem with no radiation conditions
at infinity.

An interior *electromagnetic scattering problem* in a cavity with *perfectly
electrically conducting (PEC)* boundaries meets all three. *Dipole sources*
placed inside the cavity excite a field, and the scattered field is measured
back at interior locations. This defines a *reaction operator* that maps the
dipole excitations to the corresponding field responses, and this operator
is the object of study. We constructed a probabilistic, Maxwell-consistent
*surrogate* of this reaction operator, which is a form of *operator learning*.

As comparison we will  compute the reaction operator using a second, independent
way, with a *boundary element method (BEM)* built on an *boundary integral
formulation* of the same boundary value problem. For this we used the BEM
library *`Bembel`*. The two solvers share only the problem setup and nothing of
their internal discretizations.

== Contributions

This thesis makes the following contributions.

- Maxwell EPGP library:
  Improved existing JAX implementation `maxwellgp`: fixed bugs, added support
  for tangential traces, posterior covariance computation, and sampling.
- Cavity EPGP solver:
  Built a probabilistic EPGP solver `cavity-epgp` for the cavity reaction
  operator in Python using `maxwellgp`, relying on the analytic dipole Green's
  function.
- Cavity BEM solver:
  Built a deterministic boundary element solver `cavity-bem` for the cavity
  reaction operator in C++ using `Bembel`, relying on an indirect single-layer
  formulation.
- Analytic spherical cavity solution:
  Derived a closed-form reaction operator for the spherical cavity, serving as
  exact ground truth.
- Benchmarking:
  Built a benchmark harness `cavity-benchmark`. Demonstrated convergence of
  the EPGP and BEM solvers against the analytic solution on the spherical
  cavity. Demonstrated agreement between the two solvers on the ellipsoidal
  cavity, which has no analytic solution. Reported a 2D convergence grid and an
  accuracy-runtime trade-off.
