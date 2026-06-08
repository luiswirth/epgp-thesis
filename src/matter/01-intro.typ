= Introduction

== Context and Motivation

*Machine learning (ML)* is increasingly used as a tool in the sciences and
engineering, where the systems of interest obey well-established physical laws.
This has given rise to the field of *AI for science and engineering (AISE)*,
also known as *AI4Science* or *scientific machine learning (SciML)*. A purely
data-driven model ignores the known physical structure and must rediscover the
laws from data alone, which is wasteful and typically inaccurate outside the
regime it was trained on. The more principled approach embeds established
physical knowledge into the model from the outset. This idea appears under
several names, including *first-principles AI*, *hybrid modeling*, and
*physics-informed ML*, which all refer to essentially the same goal: letting the
governing equations constrain the model rather than fitting them as targets. A
further demand specific to science and engineering is *uncertainty
quantification*: a prediction is only actionable when it carries a calibrated
estimate of its own reliability.

Many physical laws take the form of *partial differential equations (PDEs)*, and
there are two ways to make a model respect such a law. Weak enforcement adds
the PDE residual as a penalty in the training objective, so the constraint is
only satisfied approximately and is traded off against the data; the
physics-informed neural network is the canonical example. *Strong enforcement*
instead restricts the model to functions that satisfy the equation exactly by
construction, so the physics holds identically regardless of the data. Strong
enforcement is clearly preferable, since the model can then never violate the
law it is meant to obey.

Among ML models, the *Gaussian process (GP)* is particularly well suited to
strong enforcement. A GP is a probabilistic model over functions that returns a
full posterior distribution rather than a point estimate, so uncertainty
quantification is intrinsic to it. If the GP prior is built so that its samples
satisfy a PDE exactly, the model is strongly physics-informed and probabilistic
at the same time. Using a GP this way to represent the solution of a PDE places
the method within *probabilistic numerics*, and the resulting object is a
*surrogate model* of the underlying solution that carries its own uncertainty
estimates.

The *Ehrenpreis--Palamodov (EP)* framework provides a constructive route to such
priors for linear PDEs with constant coefficients, representing solutions as
superpositions of exponential modes supported on the characteristic variety of
the operator. Its GP realization, the *Ehrenpreis--Palamodov Gaussian
Process (EPGP)* @harkonen, builds the governing equations directly into the
prior, so that every sample and every posterior estimate lies in the solution
space of the operator exactly.

This thesis is concerned with *electromagnetism (EM)*, governed by *Maxwell's
equations*. It contributes to an ongoing effort @felix to construct EPGP priors
for the *time-harmonic* Maxwell system from a geometric perspective based on
*differential forms (DFs)*, the *de Rham complex*, and *Hertz potentials*. The
resulting prior is a superposition of *plane waves* that individually solve
Maxwell's equations, so the GP is Maxwell-consistent by construction.

The theoretical framework and a proof-of-concept exist, but a convincing
reference benchmark does not. Without a trusted, non-trivial test case, it is
difficult to assess whether the method is accurate, and to communicate that
accuracy to others.

#pagebreak(weak: true)

== Problem Statement

A useful benchmark for the Maxwell EPGP method should satisfy three requirements.
It should be governed by the time-harmonic Maxwell equations, it should admit
synthetic data generation so that no measurement noise confounds the comparison,
and it should be well matched to an interior plane-wave prior, meaning a purely
interior problem with no radiation condition at infinity.

An interior electromagnetic scattering problem in a *perfectly electrically
conducting (PEC)* cavity meets all three. Dipole sources placed inside the cavity
excite a field, and the scattered field is measured back at interior locations.
This defines a reaction operator that maps the dipole excitations to the
corresponding field responses, and this operator is the object of study. Such
interior solution operators arise in *inverse scattering* @cavity, where they
underlie sampling methods for cavity identification, and constructing a
probabilistic, Maxwell-consistent surrogate of one is a form of *operator
learning*.

The difficulty is that the EPGP solution has no ground truth to compare against.
We resolve this by computing the reaction operator a second, independent way, with a
*boundary element method (BEM)* built on an integral formulation of the same
boundary value problem. The two solvers share only the geometry, the measurement
points, and the wavenumber, and nothing of their internal discretizations. Their
agreement therefore validates both at once, since two methodologically unrelated
schemes are unlikely to reproduce the same wrong answer.

== Contributions

This thesis makes the following contributions.

- A deterministic BEM reference solver for the interior cavity problem, built on
  the Bembel library @bembel, together with a convergence study that establishes
  its reference quality.
- An EPGP reconstruction of the same reaction operator, extending the
  Maxwell-consistent plane-wave GP implementation of @felix to the cavity
  benchmark.
- A shared-configuration orchestration that drives both solvers from one
  specification and cross-validates the two computed operators against each
  other.
