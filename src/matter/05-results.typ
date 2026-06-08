#import "../setup-math.typ": *

// Bold grid around the label column (first column): both vertical edges plus
// every horizontal divider between the n label cells.
#let labelbox(n) = (
  table.vline(x: 0, stroke: 1.5pt),
  table.vline(x: 1, stroke: 1.5pt),
  ..range(n + 1).map(y => table.hline(y: y, end: 1, stroke: 1.5pt)),
)

// BEM convergence runs, sorted by (p, m). Columns: p, m, dofs, recip, selfconv, secs.
#let bem-runs = csv("../../res/bem_results.csv").slice(1).sorted(
  key: r => (int(r.at(0)), int(r.at(1)))
)
// EPGP convergence runs, sorted by n_spectral. Columns: n_spectral, recip, err_vs_bem.
#let epgp-runs = csv("../../res/epgp_results.csv").slice(1).sorted(
  key: r => int(r.at(0))
)

= Results and Discussion

This chapter reports the numerical results of the benchmark. We first establish
the deterministic BEM reference and characterize its convergence in @sec:res-bem,
then present the EPGP reconstruction and its convergence in @sec:res-epgp, and
finally cross-validate the two solvers against each other in @sec:res-comparison.
Throughout, we use the relative *reciprocity error*
$
  rho := norm(amat(T) - amat(T)^transp) / norm(amat(T))
$ <eq:reciprocity>
as a cheap, reference-free self-consistency indicator. Because transmitters and
receivers coincide on $Lambda$, reciprocity of the underlying physics forces the
discrete reaction operator $amat(T)$ to be symmetric in exact arithmetic, so
$rho$ measures the violation of a property the true operator satisfies exactly.
It is a necessary but not sufficient condition for accuracy; its limitations
are discussed below.

== Deterministic Reference Solution <sec:res-bem>

The BEM reference operator is assembled with the indirect single-layer
formulation of @sec:impl on a sequence of discretizations parametrized
by two knobs: the mesh refinement level $m$, which drives $h$-refinement, and the
polynomial degree $p$, which drives $p$-refinement. Because the ellipsoidal
boundary is analytic, the geometry
carries no singularities that would limit the approximation order, and one
expects algebraic convergence under $h$-refinement but exponential convergence
under $p$-refinement. The number of degrees of freedom scales as $C(p) dot 4^m$.

@tab:bem lists the complete set of BEM runs and @fig:bem-reciprocity plots the
reciprocity error $rho$ over the $p times m$ grid. The two refinement directions
behave qualitatively differently, as anticipated: $h$-refinement reduces $rho$
algebraically, whereas $p$-refinement reduces it geometrically. At the finest mesh
level $m = 4$, shown in the corresponding columns of @tab:bem, increasing the
polynomial degree drives the reciprocity error down by roughly one to two orders
of magnitude per degree, with the per-degree gains shrinking as the floor is
approached. The
best attainable run, p4m4 with $4332$ degrees of freedom, reaches
$rho approx 2.0 times 10^(-9)$, close to the round-off and dense-solver floor. We
adopt this configuration as the deterministic reference operator $amat(T)_"BEM"$
against which the EPGP solver is measured.

#figure(
  image("../../res/bem_reciprocity.svg"),
  caption: [BEM reciprocity error over the $p times m$ refinement grid.],
) <fig:bem-reciprocity>

A caveat must accompany these numbers. The reciprocity error is symmetric by
Galerkin construction and bottoms out at the round-off floor of the solver; it is
therefore not a certified measure of the true discretization error. We
illustrate this directly with the p3m4 column of @tab:bem: there the
reciprocity error lies about an order of magnitude below the self-convergence
error reported in the same column, namely the relative distance of the p3m4
operator to the finer p4m4 reference. A small reciprocity error can thus arise from
fortuitous cancellation in the antisymmetric part rather than from genuine
accuracy. We therefore treat $rho$ as an independent sanity check and rely on
self-convergence for the actual error statement. Under that reading the rapidly
diminishing per-degree gains indicate that $amat(T)_"BEM"$ is well converged at
$m 4$.

== Probabilistic Reconstruction <sec:res-epgp>

The EPGP operator is assembled by conditioning the Maxwell plane-wave GP prior
on the tangential-trace boundary data and evaluating the posterior mean of the
scattered field back on $Lambda$. The single convergence knob is the number of
spectral directions $n_"spec"$ on the Fibonacci sphere; larger $n_"spec"$ enriches
the angular bandwidth of the prior.

@tab:epgp collects the EPGP reciprocity data and @fig:epgp-reciprocity plots the
reciprocity error as a function of $n_"spec"$. It decreases with added directions
and then floors at $rho approx 5 times 10^(-10)$ for $n_"spec" gt.tilde 384$. This
level lies below the BEM reference floor, indicating that, as measured by
reciprocity, the EPGP operator is internally at least as self-consistent as the
BEM baseline.

#figure(
  image("../../res/epgp_reciprocity.svg", width: 68%),
  caption: [EPGP reciprocity error versus $n_"spec"$.],
) <fig:epgp-reciprocity>

The field reconstructions in @fig:field display the posterior-mean scattered field
on a $2"D"$ slice through the cavity, shown as its real part and as a
line-integral-convolution rendering of the field lines. They are visually smooth
and free of artefacts, as expected for a plane-wave representation of a smooth
interior field. The scattered field shown here is, like the incident field,
genuinely time-varying and carries power; the two carry equal and opposite power
flow. Their sum, the total field, is a standing wave: in a lossless PEC cavity no
net power flows, so the total field is real up to a global phase, with streamlines
stationary in time and scaling only in amplitude over a period.

#figure(
  grid(
    columns: 1,
    row-gutter: 6pt,
    image("../../res/field_real.png"),
    image("../../res/field_lic.png"),
  ),
  caption: [EPGP scattered field on a $2"D"$ cavity slice.],
) <fig:field>

A further finding concerned the construction of the
transverse polarization frame used to build the plane-wave features. The original
construction projected fixed coordinate axes onto the plane orthogonal to each
wavevector $avec(k)$, which becomes near-degenerate when $avec(k)$ aligns with a
coordinate axis. At large $n_"spec"$ some Fibonacci directions fall close to an
axis and amplify round-off substantially. Replacing this with a branchless
smallest-component pivot frame removed the degeneracy and lowered the
cross-validation floor from $ap 6 times 10^(-5)$ to $ap 6 times 10^(-8)$, about
three orders of magnitude. This shows that the accuracy ceiling of a
discretization can be set by an implementation detail rather than by the
discretization itself, and that reciprocity alone would not have revealed it.

== Comparison <sec:res-comparison>

The central result is the agreement between the two methodologically
unrelated solvers. They share only the configuration file: the geometry, points,
tangent frames, and wavenumber. Nothing of their internal discretizations is
shared, so agreement of the computed operators validates both simultaneously.

We quantify it by the relative difference of the two operators,
$
  epsilon := norm(amat(T)_"EPGP" - amat(T)_"BEM") / norm(amat(T)_"BEM"),
$ <eq:epsilon>
measured against the p4m4 BEM reference. As reported in @tab:comparison
and plotted in @fig:comparison, $epsilon$ decreases monotonically with $n_"spec"$,
reaching $epsilon approx 5.6 times 10^(-8)$ at $n_"spec" = 1024$. A boundary-integral
Galerkin scheme and a spectral plane-wave GP are entirely unrelated
discretizations, so their agreement to $ap 10^(-7)$ is strong mutual validation.

#page(flipped: true)[
  #figure(
    text(size: 8pt)[#table(
      columns: (auto,) + (1fr,) * bem-runs.len(),
      align: right,
      stroke: 0.5pt,
      ..labelbox(6),
      [$p$], ..bem-runs.map(r => [#r.at(0)]),
      [$m$], ..bem-runs.map(r => [#r.at(1)]),
      [DOFs], ..bem-runs.map(r => [#r.at(2)]),
      [$rho$], ..bem-runs.map(r => sci(r.at(3))),
      [self-conv.], ..bem-runs.map(r => if float(r.at(4)) == 0 { [---] } else { sci(r.at(4)) }),
      [$t$ [s]], ..bem-runs.map(r => [#r.at(5)]),
    )],
    caption: [BEM convergence over the $p times m$ grid.],
  ) <tab:bem>

  #v(1.5em)

  #figure(
    text(size: 8pt)[#table(
      columns: (auto,) + (1fr,) * epgp-runs.len(),
      align: right,
      stroke: 0.5pt,
      ..labelbox(2),
      [$n_"spec"$], ..epgp-runs.map(r => [#r.at(0)]),
      [$rho$], ..epgp-runs.map(r => sci(r.at(1))),
    )],
    caption: [EPGP reciprocity error versus $n_"spec"$.],
  ) <tab:epgp>

  #v(1.5em)

  #figure(
    text(size: 8pt)[#table(
      columns: (auto,) + (1fr,) * epgp-runs.len(),
      align: right,
      stroke: 0.5pt,
      ..labelbox(2),
      [$n_"spec"$], ..epgp-runs.map(r => [#r.at(0)]),
      [$epsilon$], ..epgp-runs.map(r => sci(r.at(2))),
    )],
    caption: [EPGP--BEM relative operator difference versus $n_"spec"$.],
  ) <tab:comparison>
]

#figure(
  image("../../res/epgp_vs_bem.svg", width: 68%),
  caption: [EPGP--BEM relative operator difference versus $n_"spec"$.],
) <fig:comparison>

Two observations qualify this number. First, the cross-validation error is still
decreasing at $n_"spec" = 1024$ and has not yet floored, so $epsilon approx 5.6 times 10^(-8)$
is best read as an upper bound on the achievable agreement rather than a
converged value. Second, the residual disagreement reflects
genuine discretization differences rather than numerical noise in either solve:
both solvers' reciprocity floors, $ap 2 times 10^(-9)$ for BEM and $ap 5 times
10^(-10)$ for EPGP, lie well below $epsilon$. Because
the EPGP reciprocity floor is roughly two orders of magnitude below the gap, the
residual cannot be attributed to internal EPGP round-off; it is dominated by the
finite angular resolution of the plane-wave prior together with the finite BEM
mesh. Both solvers thus operate well within their numerical floors, and the
benchmark conclusion stands: two unrelated Maxwell solvers agree at the
$10^(-7)$ level.

== Sensitivity and Uncertainty Analysis
