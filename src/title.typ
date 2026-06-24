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

// Alternative Titles:
// - Learning Electromagnetic Fields in PEC Cavities: A Boundary Element Method Benchmark for Ehrenpreis-Palamodov Gaussian Processes
// - Flagship Example for Learning Electromagnetic Fields through Ehrenpreis-Palamodov Gaussian Processes

#[
  #set text(25pt)
  *Ehrenpreis--Palamodov Gaussian Process \
  for Maxwell's Equations: \
  Boundary Element Method Benchmark \
  for PEC Cavity Reaction Operator*
]

#v(1cm)
#text(20pt)[
  _Luis Wirth_
]
\
#text(13pt)[
  #weblink("mailto:luwirth@ethz.ch", "luwirth@ethz.ch") \
  #weblink("http://ethz.lwirth.com", "ethz.lwirth.com")
]

#v(1cm)
Supervised by

#text(16pt)[
  _Prof. Dr.-Ing. Stefan Kurz_ \
]
Seminar for Applied Mathematics

#[
  #set align(bottom)
  #set text(15pt)
  #datetime.today().display("[day]th [month repr:long] [year]")
]

