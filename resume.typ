// Secrets

#let redact = true
#let secrets_var = (:)

#if not redact {
  import "secrets.typ": secrets
  secrets_var = secrets
}

#let error-text(msg) = text(fill: red, "⟨" + msg + "⟩")
#let redacted = error-text("Redacted")

#let secret(name, default: redacted) = secrets_var.at(name, default: default)
#let with-secret(name, f, default: redacted) = if name in secrets_var { f(secrets_var.at(name)) } else { default }

// Overall typography

#let rem = 11pt

#set document(
  title: secret("legal-name", default: "[Redacted]") + "'s resume",
)

#set page(paper: "us-letter", margin: .5in, footer: text(
  fill: black.transparentize(75%),
  size: 9pt,
)[#h(1fr) Typeset in #link("https://typst.app/home")[#text(fill: rgb("004466").transparentize(75%))[Typst]] #sys.version])

#set text(
  font: "Libertinus Serif",
  size: rem,
  lang: "en",
  region: "US",
)

#show title: set text(size: 2 * rem, weight: "regular")

#show heading.where(depth: 1): it => block(
  stroke: (top: 0.75pt + luma(221)),
  width: 100%,
  above: .5 * rem,
  below: 1.2 * rem,
  inset: (top: 5pt),
  text(
    size: 1.36 * rem,
    weight: "regular",
    it.body,
  ),
)

#set par(spacing: 0.65em)
#set list(indent: 0.5em)
#show raw: set text(font: "Iosevka Moe", size: 0.833 * 1em / 0.8)
#show link: set text(fill: rgb("004466"))

// Building blocks

#let blackout(n) = text(tracking: -0.05em, range(n).map(i => "█").join())
#let linkurl(url) = link(url, url)
#let contact-item(key, value) = [*#key* #h(1pt) #value #h(rem, weak: true)]

#let entry(content) = [
  #content
  #v(.9em)
]

#let entry-heading(content) = [
  #content
  #v(1pt)
]

#let split(left, right) = grid(
  columns: (auto, 1fr),
  column-gutter: 3pt,
  align: (alignment.left, alignment.right),
  left, right,
)

// Convenience functions

#let email-link(email) = link("mailto:" + email)[#email]
#let github-link(username) = link("https://github.com/" + username)[#username]
#let linkedin-link(username) = link("https://www.linkedin.com/in/" + username)[linkedin.com/in/#username]

#let position(
  title,
  from: error-text("unknown start date"),
  to: [Present],
  location: error-text("unknown location"),
) = split(emph(title), emph[#location #h(2pt) *‧* #h(2pt) #from -- #to])

#let experience(affiliation, positions, body) = entry[
  #entry-heading(split(
    strong[#affiliation,],
    if type(positions) == array { positions.join() } else { positions },
  ))
  #body
]

#let project(name, url, body) = entry[
  #entry-heading(split(
    strong(name),
    emph(if url != none {
      linkurl(url)
    } else {
      text("(WIP)", luma(128))
    }),
  ))
  #body
]

#let reference(name, email, body) = entry[
  #entry-heading(strong(name), emph(email-link(email)))
  #body
]

// Content

#title[#secret("legal-name", default: [#blackout(9) #text(size: 0.75em)[_a.k.a._ "daylily"]])]

#entry[
  #contact-item[Email][#email-link("i@dayli.ly")]
  #contact-item[Phone][#secret("phone-number", default: blackout(10))]
  #contact-item[GitHub][#github-link("coclique")]
  #contact-item[LinkedIn][#with-secret("linkedin-profile", linkedin-link, default: blackout(14))]
]

= Education

#experience([Carnegie Mellon University], position(
  [B.S. in Computer Science (GPA 4.00)],
  from: [Aug 2023],
  to: [Dec 2026],
  location: [Pittsburgh, PA],
))[
  - Coursework in: programming language theory, compiler design, database systems, parallel computing, distributed systems, category theory, introductory theory of computation, introductory HCI, vector calculus, statistics
]

= Work Experience

#experience([#secret("undisclosed-financial-institution", default: "Undisclosed financial institution")], (
  position([Dev Intern], from: [May 2026], to: [Aug 2026], location: [New York, NY]),
))[
  - #text(
      fill: luma(128),
    )[I cannot discuss details about this internship because my work is yet to conclude]
]

#experience([Google], (
  position([Software Engineering Intern (Travel Ads)], from: [May 2025], to: [Aug 2025], location: [Mountain View, CA]),
  position([STEP Intern (Google Learning)], from: [May 2024], to: [Aug 2024], location: [New York, NY]),
))[
  - (2025) Built a bidding simulation pipeline that verified the increased earning potential of ROAS bidding in Hotel Ads
  - (2024) Implemented the key concept cards feature in the Google Search math solver and a related Gemini integration
]

#experience([MLabs Ltd.], position(
  [Software Consultant (Haskell & Plutus)],
  from: [Oct 2021],
  to: [May 2023],
  location: [London, UK (Remote)],
))[
  - Developed an embedded DSL in Haskell for writing and visualizing #link("https://cardano.org/")[Cardano blockchain] transaction specifications
  - Implemented unit and property testing libraries for the Plutus smart contract language
]

#experience([Taichi Graphics], position(
  [Intern Compiler Engineer],
  from: [Nov 2021],
  to: [Mar 2023],
  location: [Beijing, China],
))[
  - Proposed and implemented a type system for the #link("https://github.com/taichi-dev/taichi")[Taichi compiler], in place of ad-hoc validation logic
  - Implemented various smaller-scale refactors and compiler passes, such as short-circuiting logical operators
]

#experience([Chinese Academy of Sciences], position(
  [Intern Research Engineer (PLCT Lab)],
  from: [Oct 2020],
  to: [Oct 2021],
  location: [Beijing, China],
))[
  - Core contributor to the open source HoTT proof assistant #link("https://github.com/aya-prover/aya-dev")[Aya Prover], mainly on its module and type systems
]

= Personal Projects

#project([Cleff], "https://github.com/coclique/cleff")[
  - Efficient and expressive effect handlers in Haskell, 2--5x performance gain compared to mainstream libraries
  - Presented at #secret("cleff-venue", default: blackout(27))\; project gained 100+ stars on GitHub
]

#project([Inkclip], "https://github.com/coclique/inkclip")[
  - A lightweight e-ink wearable accessory as an exercise in blending technology and self-expression
  - Custom STM32-based PCB, Rust (#link("https://embassy.dev/")[embassy]) firmware, and #link("https://svelte.dev/")[Svelte]-based web interface using #link("https://developer.mozilla.org/en-US/docs/Web/API/WebHID_API")[WebHID] communication
]

#project([Lilynet (AS401736)], "https://daylily.network")[
  - Educational dual-stack (IPv4+v6) network participating in global internet routing, active voting member of #link("https://www.arin.net/")[ARIN]
  - 3 virtual PoPs providing services including authoritative DNS, Tor relays, IPv6 tunneling, and anycast routing
]

// #project([Orizuru.app], none)[
//   - Federated, anonymous Q&A-based social media platform, built on #link("https://www.w3.org/TR/activitypub/")[ActivityPub], interoperable with #link("https://jointhefediverse.net")[the Fediverse]
//   - Full-stack web application developed with #link("https://svelte.dev/docs/kit/introduction")[SvelteKit], #link("https://tailwindcss.com/")[TailwindCSS], #link("https://trpc.io/")[tRPC], #link("https://www.postgresql.org/")[PostgreSQL], and #link("https://fedify.dev/")[Fedify]
// ]

= Miscellaneous

#entry[
  - *Specializations:* functional programming; compilers and type systems; full-stack web development; among others
  - *Programming languages:* Haskell, TypeScript, HTML/CSS, OCaml, Kotlin, Java, C/C++, Rust, Python, LaTeX, etc.
  - *Natural languages:* bilingual in English and Mandarin
]

