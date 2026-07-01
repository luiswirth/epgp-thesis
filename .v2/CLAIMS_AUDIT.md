# V2 Claims Audit

Purpose: respond to the directive to *eliminate unvalidated interpretations or
make them explicit speculation, and verify all claims*. This is a claim-by-claim
sweep of the interpretive/physical statements in the thesis (mainly Ch. 4
Results and Ch. 5 Conclusion, where interpretation lives). Ch. 2–3 are
established-fundamentals exposition (Kurz asked us to keep them stable); their
assertions are standard physics/math and are cited rather than re-derived.

Classification per claim:
- **KEEP-data** — directly supported by a shown figure/table/data value.
- **KEEP-theory** — a standard mathematical/physical fact (cited where useful).
- **SOFTENED** — was stated as fact, is actually an unvalidated interpretation;
  reworded to explicit conjecture ("possible explanation", "consistent with",
  "suggesting", "open question"). No new computation.
- **CORRECTED** — was technically wrong/overstated; fixed to a defensible claim.

All SOFTENED/CORRECTED edits are highlighted in the review build.

---

## Chapter 4 — Results

| # | Location | Claim | Disposition |
|---|----------|-------|-------------|
| C1 | §4.1.1 Mean | "both … are traveling waves carrying energy, but their energy flows cancel, so the total field is a pure standing wave" | **SOFTENED** (KURZ 33). No Poynting vector computed; reframed as an interpretation consistent with the ringlike figure, explicitly not demonstrated. Poynting analysis → paper backlog. |
| C2 | §4.1.1 Mean | "field lines via LIC" (×3 across sphere+ellipsoid) | **CORRECTED** terminology (KURZ 32): LIC is a texture whose streaks follow the local field direction, not field lines. |
| C3 | §4.1.1 Mean | "incident field is the dipole near field, sharply localized at the source"; "wavefronts are concentric"; "smooth rings" | **KEEP-data** — directly visible in @fig:sphere-field. |
| C4 | §4.1.1 Uncertainty | "The reason is that we condition only on the tangential part … normal component is left free … uncertainty fades toward the center" | **SOFTENED** (KURZ 35) to "a possible explanation". Mechanism not proven. |
| C5 | §4.1.1 Uncertainty | "The map thus shows how well the boundary data determines the field, not the size of the true reconstruction error." | **KEEP-theory** — correct, and Kurz praised it explicitly. Untouched. |
| C6 | §4.1.2 Operator | "largest entries lie along the diagonal, where each dipole couples most strongly to itself and its near neighbours" | **SOFTENED** to "consistent with" — diagonal dominance is observed, the self-coupling reason is an interpretation. |
| C7 | §4.1.2 Operator | "posterior covariance is fixed only by where we condition and where we evaluate, not by the measured values" | **KEEP-theory** — textbook GP fact (R&W Ch. 2); covariance is data-independent. |
| C8 | §4.1.2 Operator | "On the sphere, symmetry makes all receivers equivalent, so σ is uniform" | **KEEP-data/theory** — uniformity visible; symmetry argument sound. |
| C9 | §4.1.2 Convergence | two-regime description of the convergence curves | **SOFTENED→sharpened** (KURZ 41a): adopted Kurz's explicit "crossover between two error regimes" wording. Data-backed reading of the figure. Semilog re-plot deferred (paper). |
| C10 | §4.1.2 Noise | "growth is nearly a straight line … power-law dependence"; "covariation does not mean uncertainty tracks reconstruction error" | **KEEP-data** — straight line on log–log axes; the caution is correct. |
| C11 | §4.1.4 k-sweep | "Every dip of σ_min coincides with an analytic resonance … k=2 sits at a local maximum" | **KEEP-data** — the coincidence is shown in @fig:sphere-ksweep. (Operator definition still owed → KURZ 37, substantive, pending.) |
| C12 | §4.2.1 Uncertainty | "The lobes sit where the field hits the wall most steeply, so its normal component is large …" | **SOFTENED** (KURZ 39) to explicit conjecture; not verified against the boundary-normal component. Quantitative plot → paper backlog. |
| C13 | §4.2.2 Operator | "…because the boundary data constrains near-wall receivers more tightly than deep-interior ones" | **SOFTENED** (KURZ 40) to "suggesting that…" (Kurz's exact wording). |
| C14 | §4.2.2 / §4.2.4 Convergence | "floors at ρ≈3e-11, confirming symmetric to that level"; BEM "decay is consistent with … established on the sphere" | **KEEP-data** — ρ floor is measured; BEM statement already hedged ("consistent with"). |
| C15 | §4.2.5 Cross-validation | "9e-9 is an upper bound … at least this close"; "strong combined evidence that both compute the correct operator" | **KEEP-data/reasoned** — bound follows from the monotone decrease; conclusion hedged as "evidence", not proof. |
| C16 | §4.2.5 Cost | "two to three orders of magnitude faster"; "cost dominated by the one-off factorization"; asymptotic O(·) scalings | **KEEP-data** for the measured factor and the observed near-vertical front; scalings are standard complexity. Caveat added (see C17). |

## Chapter 5 — Conclusion

| # | Location | Claim | Disposition |
|---|----------|-------|-------------|
| C17 | §5.1 Summary | "cheaper solver … two to three orders of magnitude faster than the BEM" | **SOFTENED** (KURZ 43): added caveat pointer (unoptimized BEM, no fast-multipole/compression). Fair fast-BEM comparison → paper backlog. |
| C18 | §5.2 Limitations | validation-scope and symmetry hedges | **KEEP** — already appropriately hedged; untouched. |
| C19 | §5.2 Limitations | "reciprocity error … constrains only the antisymmetric part of the error" | **KEEP-theory + elaborated** (KURZ 44): added the symmetric/antisymmetric decomposition showing why a symmetric error is invisible to ρ. |
| C20 | §5.2 UQ | "dominant error … systematic bias … a Gaussian variance cannot represent a bias"; "optimizing σ_n drives it toward a floor" | **KEEP** — Kurz explicitly agreed (46.1, 46.2). |
| C21 | §5.2 UQ | "condition number grows like 1/σ_n² as the noise decreases" | **CORRECTED** (KURZ 46.3). Theory: A = W⁻¹ + ΦΦ^H/σ_n²; as σ_n→0, A is dominated by ΦΦ^H/σ_n², so cond(A) approaches cond(ΦΦ^H) (set by the feature spectrum), it does **not** follow a clean 1/σ_n² law. Verified by reasoning; no new runs. Deeper analysis → paper backlog. |
| C22 | §5.2 UQ / §5.3 Future Work | "A more principled quadrature would relieve this"; "[Lebedev] should … give a smaller and better-conditioned system" | **SOFTENED** (KURZ 46.4) to an open question: good integration accuracy does not imply a well-conditioned feature matrix (conditioning is set by feature correlations, not quadrature accuracy). |
| C23 | §3.1.4 Hyperparameters | "[σ_n] marginal-likelihood optimum is governed by the condition number of the system rather than by the data" | **CORRECTED/aligned** with C21: reworded to "driven toward the numerical floor of the ill-conditioned feature system rather than toward a data-appropriate value", cross-referenced to the conclusion. |

---

## Still-owed substantive items (not pure softening; pending)

These are technical/structural, not covered by this softening pass:
- **KURZ 21 / 25** — make the prior weight covariance W explicit and restructure
  the Weight-Space Posterior per Kurz's rewrite.
- **KURZ 24** — how the transverse basis is selected + Π_k-invariance argument.
- **KURZ 37** — explicit definition of the σ_min operator (reproducibility).
- **KURZ 9** — scattered vs. total field read by the receiver (physics clarity).

## Explicitly deferred to the paper (require new computation)

- Poynting-vector analysis (C1), uncertainty-vs-boundary-normal plot (C12),
  semilog Ns-convergence plot (C9), condition-number theory (C21),
  quadrature-vs-conditioning study (C22), fast-BEM-fair cost comparison (C17).
