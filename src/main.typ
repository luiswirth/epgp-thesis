#import "setup.typ": *
#show: thesis-template

#preface-style[
  #include "title.typ"
  #include "toc.typ"
]

#body-style[
  #include "matter/01-intro.typ"
  #include "matter/02-math.typ"
  #include "matter/03-bench.typ"
  #include "matter/04-impl.typ"
  #include "matter/05-results.typ"
  #include "matter/06-conclusion.typ"
]

#appendix-style[
  #include "appendix/sphere-analytic.typ"
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
