# KURZ_REVIEW — V2 working briefing

This file is the single source of truth for revising the semester thesis
(*BEM Benchmark of the Ehrenpreis–Palamodov Gaussian Process for Maxwell
Cavity Scattering*) into V2, based on Stefan Kurz's written feedback.

It contains every annotation Kurz made in the commented PDF, verbatim,
plus triage and a concrete fix for each. You (Claude Code) do not need the
original PDF — everything is here. The verbatim comment is given for every
item so you can always see the ground truth and overrule the triage if the
fix misreads intent.

The thesis source is Typst. The repo is `epgp-thesis`
(github:luiswirth/epgp-thesis). Build with `./build.sh` from the root.

---

## Governing constraint (read first)

Kurz's cover email, verbatim on the scope of V2:

> Ich möchte anregen, dass Du die Kommentare durcharbeitest und eine V2
> erstellst. **Bitte investiere dabei nicht übermäßig viel Zeit. Der Fokus
> sollte sich anschließend auf das Paper richten.**

Translation of the operative clause: *work through the comments and make a
V2, but please do not invest excessive time; the focus should then shift to
the paper.*

His three headline improvement points from the email:
1. Clearly separate description of experimental findings from conjecture /
   interpretation.
2. Define each newly introduced object locally.
3. Reference more thoroughly in places.

His praise (for morale, and because it tells us what NOT to touch): he
called the thesis "eine außerordentlich starke Semesterarbeit," singled out
the fundamentals summary as paper-seed material, the reconstruction-error
vs. posterior-variance distinction, the experiment organization, and the
full code availability. **Do not restructure or "improve" the praised
parts.** The fundamentals chapters (Ch. 2, Ch. 3 exposition) are going into
the paper largely as-is; keep them stable.

---

## THE GOLDEN RULE FOR V2

Several comments ask for things that would require **new computation or new
figures**. For V2 we do NOT run new experiments. Where Kurz asks for a
result that would prove an interpretive claim, we **soften the claim to a
conjecture** instead of proving it. Kurz himself offered this alternative
in his comments ("A possible explanation might be..."). The new
investigations move to the paper backlog at the bottom of this file.

If a task tempts you to compute something new, stop and soften the prose
instead. The only exception is the one cheap re-plot noted in item [V2-14],
which reuses data already computed.

Scope tags used below:
- `[V2-DO]`   — do it now, document-level, in scope.
- `[V2-SOFTEN]` — reword an overconfident claim into a conjecture; no new results.
- `[COPYEDIT]` — trivial inline language fix.
- `[PAPER]`   — out of scope for V2; logged in the paper backlog, do not do now.

---

## Commit convention

- One commit per numbered item below. Message format:
  `v2(<section>): <short description>  [KURZ item N]`
  e.g. `v2(3.1.4): reframe weight-space posterior as Bayesian regression  [KURZ item 27]`
- Exception: the copy-edit cluster [V2-COPYEDITS] is a single commit:
  `v2(copyedit): address inline caret/strikeout language fixes  [KURZ copyedits]`
- Check the box here in the same commit that makes the change, so this file
  doubles as progress state. If you pick up a fresh session, unchecked boxes
  are your queue.

---

## Quarantined: new-result requests (DO NOT do in V2)

These three are the tension between the email ("light touch") and the
annotations. For V2, soften; for the paper, investigate. Cross-referenced in
the checklist and detailed in the paper backlog.

- **Poynting vector** (p.18) — proving energy-flow cancellation / standing wave.
- **Uncertainty vs. normal-component plot** (p.24) — proving the lobe explanation.
- **Semilog convergence plot** (p.20) — the one cheap exception; reuses existing
  data, so it MAY be done in V2. See [V2-14].

---

# V2 CHECKLIST (ordered by page)

Each item: verbatim Kurz comment → where it lands → the fix.

## Front matter & introduction

- [ ] **1. [V2-DO] Bembel needs a reference — abstract (p.1)**
  Verbatim: *"Add reference"* (on "Bembel").
  Where: abstract, "…an independent boundary element method (BEM) reference using Bembel."
  Fix: cite Dölz et al. 2020 at first mention of Bembel in the abstract.

- [ ] **2. [V2-DO] "between 10⁻¹⁰ and 10⁻¹²" — between what? (p.1)**
  Verbatim: *"Between what? Relative accuracy in appropriate norms?"* (on "between").
  Where: abstract, "…both solvers match it to between 10⁻¹⁰ and 10⁻¹²."
  Fix: state that these are relative errors in the Frobenius norm (as defined in
  eq. 83). Make the norm explicit in the abstract sentence.

- [ ] **3. [V2-DO] Cite the source paper for the cavity-scattering idea (p.4)**
  Verbatim: *"It might be good to add / cite the paper from which this idea was
  borrowed, to provide the context of the approach."*
  Where: §1.2, cavity scattering benchmark description.
  Fix: cite Zeng et al. 2011 explicitly as the origin of the cavity-scattering
  setup in the intro paragraph (currently only cited later in §2.2).

- [ ] **4. [V2-DO] Bembel citation in §1.2 (p.4)**
  Verbatim: *"Add citation."* (on "Bembel").
  Where: §1.2, "…we use the BEM library Bembel."
  Fix: cite Dölz et al. 2020 here too.

- [ ] **5. [V2-DO] Mention code is on GitLab for reproducibility (p.4)**
  Verbatim: *"I expect this is available on GitLab. Please do mention this. This
  is important for reproducability."*
  Where: §1.2, near "…we must rely on numerical methods alone. Since both solvers
  were already certified…their close agreement here is strong evidence…"
  Fix: add a sentence noting code + experiments are openly available (Appendix A
  already lists the repos; add a forward reference here). NOTE Kurz says GitLab;
  the thesis appendix says GitHub. Confirm which is correct and be consistent.

## Chapter 2 — Cavity Scattering

- [ ] **6. [V2-DO] Equations as sub-sentences; punctuation (p.5)**
  Verbatim: *"Throughout, equations might be regarded as (sub-)sentences,
  therefore I would add commas here, a period after eq. (2) and so on..."*
  Where: §2.1, eqs (1)–(2) and throughout.
  Fix: add terminal punctuation to display equations treated as clause endings.
  This is a throughout-the-document convention — apply globally, not just here.
  (Can fold into the copyedit cluster if you prefer, but it is document-wide.)

- [ ] **7. [V2-DO] Standard EM reference + define quantities (p.5)**
  Verbatim: *"Please add a standard reference, such as
  https://en.wikipedia.org/wiki/Classical_Electrodynamics_(book) and mention that
  the definitions of all quantities that occur in (1)-(2) can be found there. Make
  the reference specific. The reason is, otherwise you should briefly define all
  quantities yourself here."*
  Where: §2.1, source-free Maxwell eqs (1)–(2).
  Fix: add a specific reference to Jackson, *Classical Electrodynamics* (the Wikipedia
  link is to Jackson), with chapter/section, and state that E, H, D, B, ε, μ etc.
  are defined there. Make the citation specific (not just "Jackson").

- [ ] **8. [V2-DO] Fix problem dimension at the start (p.6)**
  Verbatim: *"In three dimensions! The dimension of the problem should be fixed in
  the beginning."*
  Where: §2.2 / start of Ch. 2.
  Fix: state explicitly that the problem is posed in ℝ³ early in the chapter.

- [ ] **9. [V2-DO] Scattered vs. total field read by receiver (p.6)**
  Verbatim: *"Is it the scattered or the total field that is read back by the
  receiver? Physically, it should be the total field. Of course, the incident
  field is known and simple and could be easily split off."*
  Where: §2.2, "The scattered field is read back by another dipole δr…"
  Fix: clarify. Physically the receiver sees the total field; since the incident
  field is known analytically it is split off and we work with the scattered part.
  State this explicitly rather than implying the receiver reads only the scattered
  field. NOTE: this is a physics-clarity point, not just wording — make sure the
  reaction-operator definition downstream stays consistent with whatever you state.

- [ ] **10. [V2-DO] Define t/r index notation (p.6)**
  Verbatim: *"Please define index notation 't= transmitter, r= receiver'"*
  Where: §2.2, first use of δt and δr.
  Fix: define subscripts t and r at first use.

- [ ] **11. [V2-DO] Define qδ_z (p.6)**
  Verbatim: *"Please define this."* (on "qδz")
  Where: §2.2.1, oscillating monopole.
  Fix: define the point-charge source term (q the charge, δz the Dirac mass at z).

- [ ] **12. [COPYEDIT] "with density" insertions (p.6)**
  Verbatim (caret ×2): *" with density"*
  Where: §2.2.1, charge/current source description.
  Fix: insert "with density" where marked. → copyedit cluster.

- [ ] **13. [V2-DO] Citation for dyadic Green's function form (p.6)**
  Verbatim: *"Requires citation."* (on "is given by", eq. 15 explicit form)
  Where: §2.2.1, explicit form of G.
  Fix: cite a source for the closed-form dyadic Green's function (Tai 1994, or
  Colton & Kress, with specific location).

- [ ] **14. [COPYEDIT] "smooth" / "vector" insertions (p.7)**
  Verbatim (carets): *" smooth"*, *" vector"*
  Where: §2.2 / §2.3 domain and polarization descriptions.
  Fix: insert as marked. → copyedit cluster.

- [ ] **15. [V2-DO] Specific book references throughout (p.7) — GLOBAL RULE**
  Verbatim: *"Whenever you cite a book, please provide a more specific reference,
  such as equation, section, page, etc. Can you please check this throughout?"*
  Where: on "(Colton and Kress 2019)", but applies document-wide.
  Fix: go through every book citation (Colton & Kress, Tai, Rasmussen & Williams,
  Jackson once added) and add specific section/equation/page. This is a sweep, not
  a single edit. Treat as its own item/commit given its scope.

- [ ] **16. [V2-DO] Define π_t^Λ notation (p.8)**
  Verbatim: *"Define this notation."* (on the tangential projection trace on Λ)
  Where: §2.2.4.
  Fix: define the Λ-superscripted tangential trace explicitly where it first appears.

## Chapter 2 geometry & analytic solution

- [ ] **17. [V2-DO] Reference + explicit formula for Fibonacci sphere (p.9)**
  Verbatim: *"1. Requires a reference. 2. You might want to give the actual formula
  for these points. See box below."* Plus caret: *", which provides an approximately
  uniform sampling of the sphere"*.
  Where: §2.3, "…low-discrepancy quasi-uniform Fibonacci sphere distribution."
  Fix: add a reference for the Fibonacci sphere point set AND give the explicit
  point formula (Kurz asks for it in two places — here and p.13, item 25). Insert
  the caret gloss. Do the formula once and cross-reference.

- [ ] **18. [V2-DO] Define "reference-vector construction" (p.9)**
  Verbatim: *"What is meant by 'reference-vector construction'?"*
  Where: §2.3 discretization, tangent frame construction.
  Fix: explain how the orthonormal tangent frame is built from the normal via a
  fixed reference vector. NOTE this connects to the basis-rotation question
  (items 24, 26): the frame has a residual rotational freedom about the normal.

- [ ] **19. [V2-DO] Specific reference for Tai 1994 analytic solution (p.10)**
  Verbatim: *"See the general remark above: please provide a more detailed reference."*
  Where: §2.3.2, "We refer to (Tai 1994) for the full derivation…"
  Fix: give specific section/equation in Tai for the vector-spherical-harmonic
  cavity solution.

- [ ] **20. [V2-DO] Define ψ_l′ (prime on index l) (p.10)**
  Verbatim: *"What is meant by index l \prime? Please define!"*
  Where: §2.3.2, Riccati–Bessel derivative in eq. (37).
  Fix: clarify that the prime denotes the derivative of the Riccati–Bessel function
  ψ_l with respect to its argument (not an index operation). Define ψ_l(x)=x j_l(x)
  and ψ_l′ as its derivative, explicitly.

## Chapter 3 — Methods (EPGP)

- [ ] **21. [V2-DO] ⚠ SUBSTANTIVE: implicit unit-diagonal weight covariance (p.12)**
  Verbatim: *"Doesn't this silently assume that there is a unit diagonal covariance
  in the latent weight space?"* (boxed, on K(x,y)=∫ Φ_k Φ_k^H dk)
  Where: §3.1.2, Gaussian Maxwell prior kernel eq. (57).
  Fix for V2: make the prior weight covariance W explicit in the kernel definition —
  i.e. write K(x,y)=∫ Φ_k W Φ_k^H dk (or the finite version Φ^H W Φ) and state that
  the choice W=I is made later in §3.1.4 Hyperparameters. This ties off the comment
  at document level WITHOUT resolving the deeper modelling question, which is
  [PAPER]. See also items 26 and 34. This is the single most-repeated technical
  thread in the review (flagged p.12, p.14, p.30) — worth getting right in V2 prose
  even though the full treatment is paper scope. Adopting Kurz's weight-space rewrite
  (Appendix W below) makes W visible naturally.

- [ ] **22. [V2-DO] Define K_bb (p.13)**
  Verbatim: *"Define this: K_bb := K(X_b,X_b)"*
  Where: §3.1.3, posterior mean/covariance eqs (59)–(60).
  Fix: define K_bb := K(X_b, X_b) at first use.

- [ ] **23. [V2-DO] Fibonacci sphere plain-language gloss + explicit points (p.13)**
  Verbatim: *"1. May be something like: '...drawn from a Fibonacci sphere, a
  deterministic point set that provides approximately equal spacing between
  neighboring points while maintaining a nearly uniform surface-area distribution.'
  --> This would be good to help readers that are not that familiar with the
  terminology. 2. See also my prior remark, that we should somewhere state the
  points explicitly."*
  Where: §3.1.4, spectral directions from Fibonacci sphere.
  Fix: adopt his suggested gloss (or close to it) and cross-reference the explicit
  point formula from item 17. One formula, referenced twice.

- [ ] **24. [V2-DO] ⚠ SUBSTANTIVE: how is the orthonormal basis selected? (p.13)**
  Verbatim: *"How is the orthonormal basis exactly selected? It could still be
  rotated around the normal?"*
  Where: §3.1.4, "For each direction we pick an orthonormal basis a_j1, a_j2 of the
  transverse plane."
  Fix for V2: state explicitly how the transverse basis is chosen and acknowledge
  the residual rotational freedom about k_j. Then note that the projector Π_k is
  invariant under this rotation, so the prior (and hence the posterior) does not
  depend on the choice — IF that is in fact true, which it is for W=I. State this.
  This is answerable by reasoning, no computation. Cross-ref items 18, 26.

- [ ] **25. [V2-DO] ⚠ SUBSTANTIVE + restructure: Weight-Space Posterior rewrite (p.13)**
  Verbatim: *"I get your point, but I find the presentation somewhat involved. I
  tried to re-write it, with the help of ChatGPT. Find the .pdf attached. Maybe
  this inspires some re-structuring."*
  Where: §3.1.4, "Weight-Space Posterior" subsection.
  Fix: restructure per Kurz's attached rewrite (full text in Appendix W below). Key
  change: lead with the observation model h = Φ^H w + ε, ε~N(0,σ_n²I), name it as
  standard Bayesian linear regression, derive the Gaussian weight posterior from
  there. Keep your explicit two-view "solve whichever is smaller" contrast, which
  his version compresses. Making W explicit here also discharges item 21. This is
  the largest single prose task in V2 — its own commit.

- [ ] **26. [V2-DO] ⚠ SUBSTANTIVE: Hyperparameters — four sub-questions (p.14)**
  Verbatim: *"1. This approach differs from what Félix did so far (if I remember
  correctly), I deem that interesting. We should discuss this in our team. 2. There
  is also the implicit prior covariance, see my remark above. 3. Which (fixed) value
  of the regularization parameter is actually chosen? 4. What about rotation of the
  basis vectors?"*
  Where: §3.1.4, Hyperparameters paragraph.
  Fix for V2:
    - (1) team-discussion flag → [PAPER], note in backlog, no thesis action.
    - (2) implicit prior covariance → discharged by item 21 (make W explicit).
    - (3) **state the actual fixed σ_n value used.** This is a documentation gap, not
      a rerun. Retrieve from run config if not in text. Non-optional — it also
      answers the p.19 "is 10⁻³ small?" comment (item 30).
    - (4) basis rotation → discharged by item 24.

- [ ] **27. [V2-DO] Praise, action = tighten intro framing (p.15)**
  Verbatim: *"I like your account a lot. If one runs only the same chain of thoughts
  repeatedly (1. The original paper, 2. me, 3. Félix, 4. you) the essence becomes
  clearer during each sweep. I think this is a very good starting point for our
  paper."*
  Where: end of EPGP methods exposition.
  Fix: no change required (praise). Optional: nothing. Leave as-is.

## Chapter 3 — Methods (BEM)

- [ ] **28. [V2-DO] State BEM-is-concise-on-purpose in intro (p.15)**
  Verbatim: *"You treat the BEM here extremely concisely. This is OK, we agreed on
  it. The reason is that BEM is well established and employed only as reference
  framework. I would make this explicit in the intro paragraph."*
  Where: §3.2 opening (and/or §1).
  Fix: add a sentence stating BEM is presented concisely by design, as a
  well-established method used only as an independent reference.

- [ ] **29. [COPYEDIT→borderline] insert "formally" (p.16)**
  Verbatim: *"' formally'. I would write 'formally' since you did not discuss
  existence of the inverse etc."*
  Where: §3.2.1, BVP solution operator S = Ψ_SL V⁻¹ (eq. 74).
  Fix: insert "formally" before the inverse-operator statement. Slightly more than
  cosmetic (it's a correctness hedge) but a one-word fix. Can go in copyedit cluster
  or its own tiny commit.

- [ ] **30. [V2-DO] Reference for Galerkin double-integral form (p.17)**
  Verbatim: *"It would be good to add a specific reference here, e.g., from the
  papers of Ralf Hiptmair."*
  Where: §3.2.3, integration-by-parts reduction to double surface integral, eq. (82).
  Fix: cite a specific Hiptmair reference (Buffa & Hiptmair 2003 is already in the
  bibliography — add specific location).

## Chapter 4 — Results (spherical cavity)

- [ ] **31. [V2-DO] Reference for Frobenius-bounds-operator-norm (p.18)**
  Verbatim: *"Very good. Please add a reference for this result."*
  Where: §4 preamble, ‖T‖_op ≤ ‖T‖_F, eq. (84).
  Fix: cite a standard matrix-analysis reference (e.g. Horn & Johnson) for the norm
  inequality.

- [ ] **32. [V2-SOFTEN] LIC "field lines" terminology (p.18, p.23 ×2)**
  Verbatim: *"Is it really field lines? In my understanding, LIC produces a texture
  whose streaks follow the local field direction."*
  Where: §4.1.1 and §4.2.1, LIC figure descriptions ("field lines via LIC").
  Fix: reword "field lines" → e.g. "a line-integral-convolution (LIC) texture whose
  streaks follow the local field direction" (or "streamline texture"). Apply at all
  three occurrences. Terminology correction, not a claim to soften — but same
  mechanical nature.

- [ ] **33. [V2-SOFTEN] ⚠ QUARANTINED (Poynting): energy-flow / standing-wave claim (p.18)**
  Verbatim: *"Hm, this sounds slightly overconfident. To make statements on energy
  flows and standing waves, the Poynting vector should be computed and analyzed /
  plotted."*
  Where: §4.1.1 Mean, "…both…are traveling waves carrying energy, but their energy
  flows cancel, so the total field is a pure standing wave."
  Fix for V2: **soften, do not compute.** Reword to describe what the figure shows
  (concentric wavefronts, ringlike LIC texture) and frame the energy-flow / standing-
  wave reading as consistent-with rather than demonstrated. The Poynting-vector
  computation is [PAPER] (backlog). Do NOT add a Poynting plot in V2.

- [ ] **34. [V2-DO] ⚠ SUBSTANTIVE: "10⁻³ is small" needs normalization + σ_n (p.19)**
  Verbatim: *"Hm... Why is 10^-3 deemed small? The uncertainty is a physical quantity
  and bears the same physical dimension as the field, so '10^-3 = small' does not
  make sense per se. - What is the chosen normalization? One might safely say 'The
  posterior standard deviation is on the order of 10^-3 in the chosen normalization.'
  - How is the regularization parameter sigma_n chosen? Section 'Hyperparameters'
  says that it is fixed but its value seems to be undocumented."*
  Where: §4.1.1 Uncertainty, "It is small, of order 10⁻³".
  Fix: (a) state the normalization and reword to "…on the order of 10⁻³ in the chosen
  normalization" rather than calling it "small" bare. (b) document σ_n — same fix as
  item 26(3); do it once, reference here. No computation.

- [ ] **35. [V2-SOFTEN] uncertainty-largest-at-wall explanation is speculative (p.19)**
  Verbatim: *"This is somewhat speculative. I would weaken this: 'A possible
  explanation might be ...' Same with the discussion above regarding the
  interpretation of Fig. 3."*
  Where: §4.1.1 Uncertainty, the tangential-conditioning / free-normal-component
  explanation.
  Fix: reword to "A possible explanation might be…". Also apply the same softening to
  the Fig. 3 interpretation above it. This is exactly Kurz's email point #1. The
  sentence "The map thus shows how well the boundary data determines the field, not
  the size of the true reconstruction error" is GOOD (he highlighted it approvingly
  elsewhere) — keep that; soften only the mechanism explanation.

- [ ] **36. [V2-COPYEDITS] inline caret/strikeout cluster — SINGLE COMMIT**
  Bundle these trivial inline fixes into one commit `v2(copyedit): ...`:
    - p.12: "carry" → "carrying" (strikeout+caret).
    - p.20: strike "are"; "consecutive index pairs **correspond to the**…" (caret "correspond to the").
    - p.20: "share a Λ point" → "share a **point on Λ**" (strike "Λ point.", caret "point on \Lambda").
    - p.6 "with density" ×2 (item 12), p.7 "smooth"/"vector" (item 14), p.9 Fibonacci
      caret gloss (part of item 17), p.16 "formally" (item 29 — or separate).
  Note: items 12, 14, 29 are cross-listed here; do them in this cluster to avoid
  commit sprawl. Items with their own substantive content (17) keep their own commit
  for the non-caret part.

- [ ] **37. [V2-DO] ⚠ reproducibility: define the σ_min operator (p.22)**
  Verbatim: *"I have a reproducability issue here: can you please add the explicit
  definition of the operator whose smallest singular value is being plotted? ---
  Except from that, I deem this analysis strong and convincing."*
  Where: §4.1.4 Wavenumber Sweep, σ_min = smallest singular value of "the boundary
  tangential trace over the orthonormalized plane-wave feature space."
  Fix: write the explicit operator whose smallest singular value is plotted — the
  matrix mapping orthonormalized plane-wave feature coefficients to their boundary
  tangential traces. Give its definition in symbols. Non-optional (reproducibility
  blocker), pure document-level, no computation.

## Chapter 4 — Results (ellipsoidal cavity)

- [ ] **38. [V2-DO] praise, structure — no action (p.23)**
  Verbatim: *"I like the idea of first presenting the sphere and then comparing the
  ellipsoid against what we have learned / observed with the sphere."*
  Fix: none. Do not touch the structure.

- [ ] **39. [V2-SOFTEN] ⚠ QUARANTINED (uncertainty-vs-normal): lobe explanation (p.24)**
  Verbatim: *"The description of the uncertainty pattern is interesting. However, the
  explanation in terms of the incidence angle and the normal component appears
  speculative. Your interpretation should be supported by an additional numerical
  analysis (e.g., relating the uncertainty to the normal component of the field at
  the boundary) in a plot."*
  Where: §4.2.1 / §4.2.2, ellipsoid uncertainty lobes explanation.
  Fix for V2: **soften, do not compute.** Reframe the incidence-angle/normal-component
  reading as a possible explanation. The uncertainty-vs-normal-component plot is
  [PAPER] (backlog). Do NOT add the plot in V2.

- [ ] **40. [V2-SOFTEN] near-wall-constraint claim → conjecture (p.24)**
  Verbatim: *"'..suggesting that the boundary data constrains receivers close to the
  wall more strongly than those deeper inside the cavity.' The language should
  indicate a possible interpretation rather than a demonstrated mechanism."*
  Where: §4.2.2, "…because the boundary data constrains near-wall receivers more
  tightly than deep-interior ones."
  Fix: adopt Kurz's exact suggested wording ("…suggesting that…"). Direct swap.

- [ ] **41. [V2-DO] ⚠ cheap re-plot ALLOWED: semilog convergence regimes (p.20-context / Fig 6)**
  Verbatim: *"This analysis very clearly illustrates the distinction between Bayesian
  uncertainty and numerical approximation error. --- Maybe write: 'The figure exhibits
  a crossover between two error regimes. For small Ns, the error is dominated by
  truncation of the spectral representation and is essentially independent of the
  number of boundary observations. Once the spectral approximation is sufficiently
  rich, the error becomes limited by the boundary discretization, producing an
  Nb-dependent error floor.' As long as Nb is big enough, would we find exponential
  convergence in Ns? For that, a semilog plot might be helpful."*
  Where: §4.1.2 Convergence, Fig. 6 discussion.
  Fix: (a) adopt his two-regime crossover wording — pure prose, do it. (b) The
  semilog re-plot reuses data you already have (Table-2 / Fig-6 runs), so it is the
  ONE allowed new figure in V2 IF trivial in the plotting harness (cavity-benchmark).
  If it is not a 5-minute change, defer the plot to [PAPER] and keep only the prose.
  Judgement call — default to prose-only if the plotting code fights you on a phone.

## Chapter 4 — comparison & cost

- [ ] **42. [V2-DO] "to" — in which norm? ×3 (p.29)**
  Verbatim: *"In which norm?"* (on "to", three occurrences)
  Where: §5.1 Summary, "matches the ground truth to ≈…", "agree to about 10⁻⁸", etc.
  Fix: specify the norm (relative Frobenius) for each match/agreement figure. Same
  underlying fix as item 2 — do consistently.

- [ ] **43. [V2-SOFTEN] EPGP-faster-than-BEM caveat (p.29)**
  Verbatim: *"Great result, however - following our discussion - to be taken with a
  grain of salt, since we didn't consider fast BEM. We have to think about how to
  best present such kind of finding in the paper."*
  Where: §5.1, "…reaching a given reciprocity error two to three orders of magnitude
  faster than the BEM."
  Fix: the Limitations section already hedges the cost comparison (unoptimized BEM,
  no fast multipole). Ensure the Summary's speed claim carries a pointer to that
  caveat / softens accordingly. The "how to present in the paper" part is [PAPER].

- [ ] **44. [V2-DO] antisymmetric-part remark deserves elaboration (p.29)**
  Verbatim: *"This is interesting and deserved more elaboration."*
  Where: §5.2 Limitations, "…since it constrains only the antisymmetric part of the
  error."
  Fix: add a sentence or two explaining why reciprocity error only sees the
  antisymmetric part and what that misses (the symmetric component of the error is
  invisible to ρ). Document-level, from existing understanding.

## Chapter 5 — Outlook

- [ ] **45. [V2-DO] Reference for Lebedev quadrature (p.30)**
  Verbatim: *"Please add a reference."* (on "Lebedev quadrature")
  Where: §5.3 Future Work.
  Fix: cite Lebedev's quadrature (e.g. Lebedev & Laikov 1999).

- [ ] **46. [V2-DO/PAPER split] ⚠ SUBSTANTIVE: Outlook UQ box — 4 points (p.30)**
  Verbatim: *"This paragraph contains several interesting aspects: 1. Very important
  observation: the posterior variance does not inform us about the reconstruction
  error. This error does not disappear by conditioning on more data. 2. The optimizer
  would drive sigma_n to the smallest numerically possible value. This is a numerical
  artifact, not a probabilistic statement. 3. Not sure about the condition number
  statement. If you look at (64), the for small σ_n the second term becomes dominant.
  The entries scale like 1/σ_n^2, but the condition number is governed by the spectrum
  of ΦΦ^H. 4. The hope would be that a better quadrature would reduce feature
  correlations and produce a better-conditioned Gram matrix. But why? A quadrature
  with excellent integration properties need not produce a well-conditioned feature
  matrix."*
  Where: §5.2/5.3, Uncertainty Quantification box + Lebedev outlook.
  Fix:
    - (1)(2) he AGREES — no change needed, these validate your text. Keep.
    - (3) **condition-number pushback.** For V2: correct/soften the claim. Your text
      says the condition number grows like 1/σ_n². Kurz notes conditioning is governed
      by the spectrum of ΦΦ^H, not simply 1/σ_n². Reword to state that the precision
      matrix A = W⁻¹ + ΦΦ^H/σ_n² is dominated by the ill-conditioned ΦΦ^H term as σ_n
      shrinks, so the conditioning of A worsens as σ_n decreases — without claiming a
      clean 1/σ_n² law for the condition number itself. You already have cond(A) values
      in Table 2; you can check the scaling against them WITHOUT new runs. Get this
      right — it's a genuine technical correction, not a hedge.
    - (4) **Lebedev hope pushback.** Soften the claim that better quadrature yields a
      better-conditioned Gram matrix. State it as a hope/expectation, and acknowledge
      Kurz's point that good integration accuracy does not imply a well-conditioned
      feature matrix. Frame as open question in Future Work.
    - Deeper resolution of (3)(4) is [PAPER].

## Appendices / declaration

- [ ] **47. [V2-DO] "Euler cluster" needs a gloss/reference (p.26)**
  Verbatim: *"Requires some reference, since this is ETH-internal terminology."*
  Where: §4.2.5, "All runs were carried out on the Euler cluster…"
  Fix: add a footnote/reference identifying Euler as ETH Zürich's HPC cluster (link
  or citation), since external readers won't know the term.

- [ ] **48. [V2-DO/discuss] Typst mention (p.32)**
  Verbatim: *"This is interesting, I was not aware of 'Typst'. Can we discuss
  occasionally, please?"*
  Where: Appendix B.
  Fix: no thesis change. Personal note — Kurz wants to chat about Typst. Log as a
  to-discuss, not a revision.

- [ ] **49. [V2-DO] AI-usage appendix (p.34)**
  Verbatim: *"Absolutely fine with me. I recommended other students to include a
  small Appendix, to make explicit the exact usage of Generative AI."*
  Where: Declaration of Originality.
  Fix: optional but recommended — add a short appendix making explicit how generative
  AI was used (which tasks, which tools). Low effort, Kurz-endorsed.

---

# Paper backlog (DO NOT do in V2 — logged for later)

Move these to the paper / raise in team discussion. They require new
computation, new figures, or deeper theory than a light V2 warrants.

- **[PAPER-A] Poynting vector analysis** (from item 33) — compute and plot the
  Poynting vector to substantiate energy-flow cancellation and the standing-wave
  characterization on the sphere.
- **[PAPER-B] Uncertainty vs. boundary-normal-component plot** (from item 39) —
  quantitatively relate posterior uncertainty to the normal component of the field
  at the boundary, to substantiate the lobe explanation on the ellipsoid.
- **[PAPER-C] Implicit prior covariance W** (from items 21, 26.2) — the deeper
  modelling question of what prior over the latent weights is actually implied, how
  it differs from Félix's construction (26.1), and whether W=I is the right choice.
  Team discussion.
- **[PAPER-D] Condition-number theory** (from item 46.3) — proper analysis of how
  the conditioning of A depends on the spectrum of ΦΦ^H and on σ_n; replace the
  heuristic 1/σ_n² statement with the real dependence.
- **[PAPER-E] Quadrature vs. conditioning** (from item 46.4) — whether a better
  quadrature (Lebedev / spherical designs) actually improves feature-matrix
  conditioning, which is not implied by integration accuracy alone.
- **[PAPER-F] Fast-BEM-fair cost comparison** (from item 43) — how to present the
  EPGP-vs-BEM speed result honestly given that fast/compressed BEM was not tested.
- **[PAPER-G] Basis-rotation robustness** (from items 24, 26.4) — if not fully
  settled by the Π_k-invariance argument in V2, a numerical robustness check.
- **[PAPER-H] Exponential convergence in Ns** (from item 41) — if the semilog plot
  is deferred, confirm/characterize exponential Ns-convergence at large Nb.
- **[PAPER-I] Team discussion items** — Félix-vs-your hyperparameter approach (26.1),
  Typst (48), and overall paper positioning of the benchmark.

---

# Consolidated "define this" quick reference

Half the review is "define X locally." Here is the full list, so you can sweep
them in one focused pass if you prefer that over per-page order:

| Object | Where | Item |
|---|---|---|
| t / r subscripts (transmitter/receiver) | §2.2 | 10 |
| q δ_z (monopole charge source) | §2.2.1 | 11 |
| dyadic Green's function G (citation) | §2.2.1 | 13 |
| π_t^Λ (Λ-tangential trace) | §2.2.4 | 16 |
| reference-vector construction (tangent frame) | §2.3 / §3.1.4 | 18 |
| ψ_l and ψ_l′ (Riccati–Bessel + derivative) | §2.3.2 | 20 |
| Fibonacci sphere: explicit points + gloss + ref | §2.3, §3.1.4 | 17, 23 |
| prior weight covariance W (make explicit) | §3.1.2 | 21 |
| transverse basis a_j1,a_j2 selection + rotation | §3.1.4 | 24 |
| K_bb := K(X_b, X_b) | §3.1.3 | 22 |
| σ_n fixed value (document it) | §3.1.4 | 26.3, 34 |
| "formally" (inverse existence hedge) | §3.2.1 | 29 |
| σ_min operator (reproducibility) | §4.1.4 | 37 |
| norm for all match/agreement figures | abstract, §5.1 | 2, 42 |
| Euler cluster (ETH HPC gloss) | §4.2.5 | 47 |

# Consolidated referencing quick reference

The other big theme. Every citation Kurz wants added or made specific:

| Reference to add / specify | Where | Item |
|---|---|---|
| Bembel (Dölz et al. 2020) | abstract, §1.2 | 1, 4 |
| Zeng et al. 2011 as idea origin | §1.2 | 3 |
| Jackson, Classical Electrodynamics (specific §) | §2.1 | 7 |
| Dyadic Green's function closed form | §2.2.1 | 13 |
| Book cites → specific §/eq/page (Colton&Kress, Tai, R&W) | throughout | 15 |
| Fibonacci sphere point set | §2.3, §3.1.4 | 17, 23 |
| Tai 1994 (specific §) | §2.3.2 | 19 |
| Hiptmair (Buffa & Hiptmair 2003, specific loc) | §3.2.3 | 30 |
| Frobenius ≥ operator norm (Horn & Johnson) | §4 | 31 |
| Euler cluster | §4.2.5 | 47 |
| Lebedev quadrature (Lebedev & Laikov 1999) | §5.3 | 45 |

---

# Appendix W — Kurz's attached weight-space rewrite (verbatim)

This is the full text of "Weight-Space Posterior.pdf" that Kurz attached to
his p.13 comment (item 25). Use it as the model for restructuring §3.1.4.

---

**Weight-Space Posterior**

The explicit feature representation of the prior admits a complementary
weight-space formulation of Gaussian process inference. Rather than
conditioning the process directly through its covariance kernel, we infer the
latent coefficient vector w in the expansion

    E(x) = Φ(x)^H w,

where w ~ N(0, W). The resulting posterior process is identical to that
obtained in function space, but the computational cost depends on the number
of features rather than the number of observations.

Evaluating the feature functions at the observation points yields the design
matrix

    Φ = Φ(X_b) ∈ C^{F × N_b},

so that the observation model becomes

    h = Φ^H w + ε,    ε ~ N(0, σ_n² I).

This is a standard Bayesian linear regression problem. The posterior over the
weights is Gaussian,

    w | h ~ N(w⋆, A⁻¹),

with posterior precision

    A = W⁻¹ + (1/σ_n²) Φ Φ^H,

and posterior mean

    w⋆ = (1/σ_n²) A⁻¹ Φ h.

The posterior mean field is obtained by mapping the inferred coefficients back
through the feature basis,

    E⋆(x) = Φ(x)^H w⋆.

The corresponding kernel under the same quadrature rule is

    K(x, y) = Φ(x)^H W Φ(y),

which is the finite-dimensional approximation used in the function-space
formulation. Substituting this expression into the standard Gaussian process
posterior and applying the Woodbury matrix identity yields exactly the
weight-space posterior above. Thus, the function-space and weight-space
formulations produce identical posterior means and covariances.

The practical distinction is computational. Function-space inference requires
inversion of the N_b × N_b Gram matrix, whereas the weight-space formulation
requires inversion of the F × F matrix A. Since the explicit-polarization
construction employs F = 2 N_s features, the weight-space formulation is
advantageous whenever F < N_b, reducing the computational cost from one
governed by the number of observations to one governed by the number of
features.

---

*Note:* his rewrite keeps W general in the kernel and precision (K = Φ^H W Φ,
A = W⁻¹ + ΦΦ^H/σ_n²), which is exactly why adopting it discharges the
"implicit unit-diagonal covariance" comment (item 21) — W becomes visible.
Your value-add over his version: keep the explicit "two equivalent views,
solve whichever dimension is smaller" framing for the thesis reader, which he
compresses. State the choice W = I where A is defined, pointing to
Hyperparameters.

---

# Session start checklist for Claude Code

1. Read this whole file. The governing constraint and golden rule are non-negotiable.
2. Work items top-to-bottom OR sweep by theme (use the "define this" and
   "referencing" tables for theme-sweeps — often faster).
3. For each item: make the edit in the Typst source, check the box here, commit
   with the convention above.
4. Never do a [PAPER] item. If an item tempts new computation, soften instead.
5. The only permitted new figure is the item-41 semilog re-plot, and only if the
   plotting harness makes it trivial. Otherwise prose-only.
6. Build with ./build.sh before committing prose that touches equations, to catch
   Typst errors.
7. If you finish all [V2-DO]/[V2-SOFTEN]/[COPYEDIT] boxes, stop. Do not gold-plate.
   Kurz: "bitte investiere dabei nicht übermäßig viel Zeit."
