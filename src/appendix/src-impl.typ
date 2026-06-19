#import "../setup.typ": *

= Implementation Source Code

== `maxwellgp`

This is the actual EPGP implementation.

#[
  #set text(size: 20pt)
  #set align(center)
  #weblink("https://github.com/luiswirth/maxwellgp")[`github:luiswirth/maxwellgp`]
]

== `cavity-epgp`

EPGP solver for the PEC cavity, thin layer over `maxwellgp`.

#[
  #set text(size: 20pt)
  #set align(center)
  #weblink("https://github.com/luiswirth/cavity-epgp")[`github:luiswirth/cavity-epgp`]
]

== `cavity-bem`

The BEM solver for the PEC cavity reference solution.

#[
  #set text(size: 20pt)
  #set align(center)
  #weblink("https://github.com/luiswirth/cavity-bem")[`github:luiswirth/cavity-bem`]
]

== `cavity-benchmark`

Cross-validation harness: aggregates BEM and EPGP results, generates figures.

#[
  #set text(size: 20pt)
  #set align(center)
  #weblink("https://github.com/luiswirth/cavity-benchmark")[`github:luiswirth/cavity-benchmark`]
]
