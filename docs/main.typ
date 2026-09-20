#show title: set align(center)
#set heading(numbering: "I.1.a.")
#show heading.where(level: 1): set align(center)
#show heading.where(level: 1): it => {
  if it.outlined [
    #align(center)[Chapter #counter(heading).display("I"). #it.body]
  ] else [
    #it
  ]
}

// -----------------------------------------------------------------------------
#set document(
  title: [Demo Document],
)
#title()
#pagebreak()
#outline()

// -----------------------------------------------------------------------------
#pagebreak()
#include "contents/chapter-1.typ"

#pagebreak()
#include "contents/chapter-2.typ"
