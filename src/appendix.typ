#import "setup.typ": *

= Implementation Source Code

== `maxwellgp`

This is the actual EPGP implementation.

#[
  #set text(size: 20pt)
  #set align(center)
  #weblink("https://github.com/luiswirth/maxwellgp")[github:luiswirth/maxwellgp]
]


== `cavity-bem`

The BEM solver for the PEC cavity reference solution.

#[
  #set text(size: 20pt)
  #set align(center)
  #weblink("https://github.com/luiswirth/cavity-bem")[github:luiswirth/cavity-bem]
]


== `cavity-dipoles`

The orchestration and validation layer.

#[
  #set text(size: 20pt)
  #set align(center)
  #weblink("https://github.com/luiswirth/cavity-dipoles")[github:luiswirth/cavity-dipoles]
]


= Document Source Code

The thesis document has been written using the new type-setting language Typst,
see #weblink("https://typst.app/")[typst.app].

The source code for this Typst document, is available on GitHub.
#[
  #set text(size: 20pt)
  #set align(center)
  #weblink("https://github.com/luiswirth/epgp-thesis")[github:luiswirth/epgp-thesis]
]

To compile the document into a PDF, the Typst compiler needs to be installed and
then the `./build.sh` script can be run from the root project directory.




