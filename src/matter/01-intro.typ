#import "../setup-math.typ": *

= Introduction

== Context and Motivation

First-Principles AI, physics-informed machine learning, the need for exact physics constraints

This semester thesis is part of an ongoing research effort @felix on
constructing Gaussian process (GP) priors that intrinsically satisfy Maxwell’s
equations. The approach follows a geometric perspective based on differential
forms and Hertz potential.

It builds on the Ehrenpreis--Palamodov (EP) framework for linear Partial
Differential Equations (PDEs) and its Gaussian process realization, called EPGP,
as introduced in @harkonen.


== Problem Statement

The theoretical construction and a proof-of-concept example are already
available, but a convincing reference benchmark is currently missing:
a physically meaningful, non-trivial test case that
- is governed by time-harmonic Maxwell equations,
- admits synthetic data generation,
- is particularly well matched to an EP plane wave GP prior (purely interior, no radiation conditions)

The goal of the semester thesis is to establish this benchmark as a robust
numerical example for probabilistic field reconstruction suitable for
publication. For a selected set of transmitting dipoles on $Lambda$, the
deterministic excitation map from dipole sources to boundary data on $partial
D$ was computed explicitly. Based on these boundary traces, an EP
plane-wave Gaussian process prior enforcing the homogeneous Maxwell system
in $D$ was conditioned to obtain a probabilistic reconstruction of the
scattered field $Ev^s$. The resulting posterior field was evaluated at
the receiver locations on $Lambda$, and uncertainty in the reconstruction was
quantified.

== Contributions

- Implemented a BEM baseline
- Constructed the EPGP pipeline
- Quantified reconstruction uncertainty


