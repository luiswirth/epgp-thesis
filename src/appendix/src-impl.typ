#import "../setup.typ": *

= Implementation Source Code

All software for this thesis is open-source on GitHub. Each repository carries a
README documenting its purpose, setup, and usage, so the code remains the single
source of truth and this thesis does not restate implementation details. The
numerical results reported here are reproducible from these repositories through
the scripts described in their READMEs.

To pin the thesis to a fixed state, the links below point to the `semester-thesis`
git tag of each repository. Later development continues on the main branch without
affecting these references.

== `maxwellgp`

The general Maxwell-constrained EPGP library: plane-wave feature maps, the GP
regression core, and tangential-trace conditioning.

#[
  #set text(size: 20pt)
  #set align(center)
  #weblink("https://github.com/luiswirth/maxwellgp/tree/semester-thesis")[`github:luiswirth/maxwellgp`]
]

== `cavity-epgp`

A thin cavity-specific layer over `maxwellgp`, owning the analytic dipole physics
and the reaction-operator assembly.

#[
  #set text(size: 20pt)
  #set align(center)
  #weblink("https://github.com/luiswirth/cavity-epgp/tree/semester-thesis")[`github:luiswirth/cavity-epgp`]
]

== `cavity-bem`

The deterministic boundary-element reference solver, built on Bembel.

#[
  #set text(size: 20pt)
  #set align(center)
  #weblink("https://github.com/luiswirth/cavity-bem/tree/semester-thesis")[`github:luiswirth/cavity-bem`]
]

== `cavity-benchmark`

Performs post-processing on the BEM and EPGP operators.
Compares to the analytic sphere reference and cross-validates the two solvers on the ellipsoid.
Gernerates all visualizations, such as plots and animations.


#[
  #set text(size: 20pt)
  #set align(center)
  #weblink("https://github.com/luiswirth/cavity-benchmark/tree/semester-thesis")[`github:luiswirth/cavity-benchmark`]
]
