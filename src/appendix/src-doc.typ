#import "../setup.typ": *

= Document Source Code

The thesis document has been written using the new type-setting language Typst,
see #weblink("https://typst.app/")[typst.app].

The source code for this Typst document is open-source and available on GitHub.
As above, the link points to the `semester-thesis` tag, the submitted version; any
later corrections appear on the main branch.
#[
  #set text(size: 20pt)
  #set align(center)
  #weblink("https://github.com/luiswirth/epgp-thesis/tree/semester-thesis")[`github:luiswirth/epgp-thesis`]
]

To compile the document into a PDF, the Typst compiler needs to be installed and
then the `./build.sh` script can be run from the root project directory.
