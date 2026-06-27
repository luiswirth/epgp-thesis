= Introduction

== Context and Motivation

*Machine learning (ML)* is increasingly used as a tool in the sciences and
engineering, where the systems of interest obey well-established physical laws.
This has given rise to the field of *scientific machine learning (SciML)*, also
known as *AI4Science*. Purely data-driven models ignore this known physical
structure and must rediscover the laws from data alone, which is wasteful and
typically inaccurate outside the regime they were trained on. The more principled
approach embeds established physical knowledge into the model from the outset.
This idea appears under several names, such as *first-principles AI (FPAI)*,
*physics-informed ML* or *hybrid modeling*, which all refer to essentially
the same idea: letting the governing equations constrain the model rather than
learning them from data.

Many physical laws take the form of *partial differential equations (PDEs)*, and
there are two ways to make a model respect such a law. Weak enforcement adds the
PDE residual as a penalty in the training objective, so the constraint is only
satisfied approximately and is traded off against the data; the physics-informed
neural network (PINN) is the canonical example @raissi. *Strong enforcement* instead restricts
the model to functions that satisfy the equation identically by construction.
*Structure preservation* is the key advantage: unphysical phenomena, such as
spurious modes or phantom charges, cannot arise. The model can
never violate the law it is meant to obey, regardless of the data. When
the governing law is known exactly, strong enforcement is therefore preferable.

Among ML models, the *Gaussian process (GP)* is particularly well suited to
strong enforcement. A GP @rasmussen is a probabilistic model over functions that returns
a full posterior distribution instead of just a point estimate. This enables
*uncertainty quantification*: every prediction carries an estimate of its own reliability.
If the GP prior is built so that its samples satisfy a PDE exactly, the model is
strongly physics-informed and probabilistic at the same time.

The *Ehrenpreis--Palamodov (EP)* principle @ehrenpreis provides a constructive route to such
priors for *linear PDEs with constant coefficients* inspired by the *inverse
Fourier transform*. It represents solutions as superpositions of *plane waves*
supported on the *characteristic variety* of the operator. Its GP realization,
the *Ehrenpreis--Palamodov Gaussian Process (EPGP)* @harkonen, uses a Gaussian prior based on this principle. The prior and the posterior both lie exactly in the solution space of the operator.

A particularly well-understood PDE system is *Maxwell's equations*, which
govern *electromagnetism (EM)*. Building a principled EPGP for these equations
is part of an ongoing effort @felix, which constructs EPGP priors for the
*time-harmonic* Maxwell system from a geometric perspective based on
*differential forms*, the *de Rham complex*, and *Hertz potentials*. This yields
a more geometrically grounded construction than the generic one by @harkonen.

The theoretical framework and a proof-of-concept exist but a convincing
reference benchmark does not. This thesis provides that benchmark.

#pagebreak(weak: true)

== Cavity Scattering Benchmark

As a benchmark we use an *interior electromagnetic scattering problem* in
a cavity with *perfectly electrically conducting (PEC)* boundaries. *Dipole
sources* placed inside the cavity act as transmitters, exciting a field. It
scatters off the PEC boundary, reflects back into the interior, and is measured
at receivers. This defines a *reaction operator* that maps the dipole
excitations to the corresponding field responses. This operator is the object of
study.

We construct a probabilistic EPGP surrogate of this reaction operator. Unlike a
purely data-driven surrogate, it satisfies the time-harmonic Maxwell equations
exactly by construction and reports its own uncertainty. Its plane-wave prior is
well suited to the interior scattering problem. The surrogate is built with the
Maxwell EPGP library *`maxwellgp`* from the ongoing work @felix.

For comparison, we compute the reaction operator in a second, independent
way, with a *boundary element method (BEM)* built on a *boundary integral
formulation* of the same underlying boundary value problem. For this we use the
BEM library *`Bembel`*. The two solvers share only the problem setup and nothing
of their internal discretizations.

We benchmark on two cavity geometries. For a *spherical cavity*, the scattered
field and the reaction operator are available in closed form. This lets us
validate the EPGP and the BEM solver independently, each against the *analytic
solution*, and thereby establish that both are correct. For an *ellipsoidal
cavity* no closed-form solution exists, so we must rely on numerical methods
alone. Since both solvers were already certified against the analytic solution
on the sphere, their close agreement here is strong evidence that both are
correct.

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
  Assembled the closed-form reaction operator for the spherical cavity from the
  standard vector spherical harmonic expansion, serving as exact ground truth.
- Benchmarking:
  Built a benchmark harness `cavity-benchmark`. Demonstrated convergence of
  the EPGP and BEM solvers against the analytic solution on the spherical
  cavity. Demonstrated agreement between the two solvers on the ellipsoidal
  cavity, which has no analytic solution. Reported a 2D convergence grid and an
  accuracy-runtime trade-off. Performed uncertainty quantification of the EPGP
  surrogate.
