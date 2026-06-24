#import "setup.typ": *
#show: thesis-template

#preface-style[
  #include "title.typ"
  #include "toc.typ"
]

#body-style[
  #include "matter/01-intro.typ"
  #include "matter/02-scattering.typ"
  #include "matter/03-methods.typ"
  #include "matter/04-results.typ"
  #include "matter/05-conclusion.typ"
]

#appendix-style[
  #include "appendix/src-impl.typ"
  #include "appendix/src-doc.typ"
]

#postface-style[
  #bibliography("bibliography.bib", style: "ieee")

  //#{
  //  set page(margin: 0cm)
  //  show heading: none
  //  heading(numbering: none)[Declaration of Originality]
  //  image("../res/declaration-originality.svg")
  //}
]
