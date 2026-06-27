#import "setup.typ": *

#show heading: none
#heading()[Title]
#set page(footer: none)

#image("../res/ethz-logo.svg")

#set align(center + horizon)
#set text(12pt)

#[
  #set text(20pt)
  Semester Thesis
]
#v(1cm)

#[
  #set text(25pt)
  *
  BEM Benchmark of the \
  Ehrenpreis--Palamodov Gaussian Process \
  for Maxwell Cavity Scattering
  *
]

#block(
    stroke: ("left": 0.5pt, "right": 0.5pt),
    fill: black.lighten(90%),
    inset: 5pt,
  )[
    *Abstract*\
    #set align(left)
    This thesis presents a high-fidelity benchmark for the Ehrenpreis--Palamodov
    Gaussian Process (EPGP), a probabilistic solver whose plane-wave prior
    satisfies the time-harmonic Maxwell equations exactly by construction. The
    benchmark is an interior electromagnetic scattering problem in a perfectly
    electrically conducting cavity, where dipole sources on an interior sphere
    excite a field that is measured back on the same sphere, defining a reaction
    operator from dipole excitations to field responses. We reconstruct this
    operator with the EPGP and validate it against an independent boundary
    element method (BEM) reference built on Bembel, on two cavity geometries. On
    a spherical cavity, where the reaction operator is available in closed form,
    both solvers match it to about $10^(-10)$. On an ellipsoidal cavity, which admits no analytic solution, the
    EPGP agrees with the BEM reference to about $10^(-8)$. This provides strong
    evidence that both solvers are correct. We further study convergence, the
    accuracy--runtime trade-off against the BEM, and uncertainty quantification.
  ]

#v(0.3cm)
#text(20pt)[
  _Luis Wirth_
]
\
#text(13pt)[
  #weblink("mailto:luwirth@ethz.ch", "luwirth@ethz.ch") \
  #weblink("http://ethz.lwirth.com", "ethz.lwirth.com")
]

#v(0.5cm)
Supervised by
#v(-0.1cm)
#text(16pt)[
  _Prof. Dr.-Ing. Stefan Kurz_ \
]
Seminar for Applied Mathematics

#[
  #set align(bottom)
  #set text(15pt)
  1st July 2026
]

