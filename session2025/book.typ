#import "@preview/theorion:0.4.1": *
#import cosmos.rainbow: *
#show: show-theorion

#set document(
  author: ("Richard Rispoli"),
  title: [Physics 203 - Livre du cours]
)

#show title: set align(right)
#show title: set block(below: 1.2em)
#show title: set text(weight: "bold", size: 1.2em, fill: rgb("#406372"))

#set page(
  paper: "us-letter",
  margin: 2cm,
  header: align(right + horizon, "Physics 203 - Commercial Engines"),
)

#set text(font: "Georgia", lang: "fr", size: 11pt)
#show heading: set text(weight: "bold", size: 1.1em, fill: rgb("#005F87"))

#title()

#outline()

#pagebreak()

#include "sessions/session_01.typ"
#pagebreak()

#include "sessions/session_02.typ"
#pagebreak()

#include "sessions/session_03.typ"
#pagebreak()

#include "sessions/session_04.typ"
#pagebreak()

#include "sessions/session_04_tp.typ"
#pagebreak()

#include "sessions/session_05.typ"
#pagebreak()

#include "sessions/session_05_solutions.typ"
#pagebreak()

#include "sessions/session_06.typ"
#pagebreak()

#include "sessions/session_07.typ"
#pagebreak()

#include "sessions/session_08.typ"
#pagebreak()

#include "sessions/session_09.typ"
#pagebreak()

#include "sessions/session_10.typ"
#pagebreak()

#include "sessions/session_11.typ"
#pagebreak()

#include "sessions/session_12.typ"
#pagebreak()

#include "sessions/session_13.typ"
#pagebreak()

#include "sessions/session_14.typ"
#pagebreak()

#include "sessions/session_15.typ"
#pagebreak()

#include "newton.typ"
#pagebreak()

#include "euler.typ"
#pagebreak()

#include "Dérivée_Intégrales.typ"
#pagebreak()

#include "runge_kutta.typ"
#pagebreak()

#include "verlet.typ"
#pagebreak()

#include "impulsion.typ"
