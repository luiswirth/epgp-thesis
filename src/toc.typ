#import "setup.typ": *

#show outline: set heading(outlined: true)
#set outline.entry(fill: line(length: 100%, stroke: 0.2pt + fgcolor))

#show outline.entry.where(
  level: 1,
): set text(weight: "bold")
#show outline.entry.where(
  level: 1,
): set block(above: 1.2em)
#show outline.entry.where(
  level: 1,
): set outline.entry(fill: none)

#pagebreak(weak: true)
#outline(
  title: "Table of Contents",
  indent: auto,
  depth: 3,
)
