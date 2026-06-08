#import "setup.typ": *

#set page(numbering: none)
#show heading: none
#heading()[Title]

#image("../res/ethz-logo.svg")


#set align(center + horizon)
#set text(12pt)

#[
  #set text(20pt)
  Semester Thesis
]
#v(1cm)

// Alternative Title:
// Learning Electromagnetic Fields in PEC Cavities:
// A Boundary Element Method Benchmark for Ehrenpreis-Palamodov Gaussian Processes
#[
  #set text(25pt)
  *Ehrenpreis--Palamodov Gaussian Process \
  for Maxwell's Equations: \
  Boundary Element Method Benchmark \
  for PEC Cavity Reaction Field*
]


#block(
  //stroke: ("left": 0.5pt, "right": 0.5pt),
  //fill: black.lighten(90%),
  inset: 5pt
)[
  #set text(10pt)
  #set align(left)

  *Keywords:*
  First-Principles AI, 
  Hybrid Modeling, 
  Physics Informed, 
  Gaussian Process, 
  Uncertainty Quantification, 
  Boundary Element Method, 
  Maxwell, 
  Electromagnetism, 
  de Rham Complex.
]

#v(1cm)
#text(25pt)[
  _Luis Wirth_
]
\
#text(15pt)[
  #weblink("mailto:luwirth@ethz.ch", "luwirth@ethz.ch") \
  #weblink("http://ethz.lwirth.com", "ethz.lwirth.com")
]

#v(1cm)
Supervised by\
#v(0.1cm)
#text(16pt)[
  _Prof. Dr.-Ing. Stefan Kurz_ \
]
Seminar for Applied Mathematics

#[
  #set align(bottom)
  #set text(15pt)
  #datetime.today().display("[day]th [month repr:long] [year]")
]
