#import "setup-math.typ": *

//#let fgcolor = white
//#let bgcolor = black
#let fgcolor = black
#let bgcolor = white

#let thesis-template(doc) = {
  show: math-template
  
  set page(fill: bgcolor)
  set text(fill: fgcolor)

  set page(paper: "a4")
  set page(margin: 1.5cm)

  set text(font: "New Computer Modern Sans")
  set text(size: 10pt)

  set par(justify: true)
 
  doc
}


#let section-style(
  label: none,
  heading-numbering: none,
  page-numbering: "1",
  reset-pagecount: false,
  outline-subheadings: true,
) = doc => {
  set page(numbering: page-numbering)
  if reset-pagecount { counter(page).update(1) }

  set heading(numbering: heading-numbering)
  counter(heading).update(0)

  show heading.where(level: 2): set heading(outlined: outline-subheadings)
  show heading.where(level: 3): set heading(outlined: outline-subheadings)

  show heading: it => {
    if it.level == 1 {
      pagebreak(weak: true)
      v(50pt)
      if label != none {
        text(size: 18pt)[#label #counter(heading).display()]
        v(0pt)
      }
      text(size: 25pt)[#it.body]
      v(20pt)
    } else {
      let size = 20pt - 4pt * (it.level - 1)
      block(sticky: true, above: size, below: size, {
        set text(size, weight: "bold")
        if it.numbering != none {
          counter(heading).display()
          h(size, weak: true)
        }
        it.body
      })
    }
  }

  doc
}

#let preface-style = section-style(
  page-numbering: "I",
)
#let body-style = section-style(
  label: "Chapter",
  heading-numbering: "1.1.1",
  reset-pagecount: true,
)
#let appendix-style = section-style(
  label: "Appendix",
  heading-numbering: "A.1.1",
  outline-subheadings: false,
)
#let postface-style = section-style(
  page-numbering: "i",
  reset-pagecount: true,
)


#let weblink(..args) = text(
  fill: blue,
  link(..args)
)
