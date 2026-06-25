#import "../setup-math.typ": *

#let bem-runs = csv("../../res/ellipse_bem_results.csv").slice(1).sorted(
  key: r => (int(r.at(0)), int(r.at(1)))
)
#let bem-sphere-runs = csv("../../res/sphere_bem_results.csv").slice(1).sorted(
  key: r => (int(r.at(0)), int(r.at(1)))
)
#let _epgp-all = csv("../../res/ellipse_epgp_results.csv").slice(1)
#let _epgp-nb-max = calc.max(.._epgp-all.map(r => int(r.at(1))))
#let epgp-runs = _epgp-all.filter(r => int(r.at(1)) == _epgp-nb-max).sorted(
  key: r => int(r.at(0))
)
#let _sphere-all = csv("../../res/sphere_epgp_results.csv").slice(1)
#let _sphere-nb-max = calc.max(.._sphere-all.map(r => int(r.at(1))))
#let sphere-runs = _sphere-all.filter(r => int(r.at(1)) == _sphere-nb-max).sorted(
  key: r => int(r.at(0))
)

= Results and Discussion

- two relative error measures used throughout, both Frobenius-norm operator differences
  normalized by the reference
  - the *reciprocity error* $rho$ is reference-free: transmitters and receivers coincide on
    $Lambda$, so reciprocity forces the true $amat(T)$ to be symmetric; $rho$ measures the
    violation, a necessary but not sufficient condition for accuracy
  - the *reference error* $epsilon$ is the distance to a trusted reference operator
$
  rho := norm(amat(T) - amat(T)^transp) / norm(amat(T)) quad quad
  epsilon := norm(amat(T) - amat(T)_"ref") / norm(amat(T)_"ref")
$
- the reference operator $amat(T)_"ref"$ is the analytic $amat(T)_star$ for the spherical
  cavity and the high-fidelity BEM operator $amat(T)_"BEM"$ for the ellipsoidal cavity
- the operator norm is bounded above by the Frobenius norm, for any matrix $amat(B)$,
$
  norm(amat(B))_"op" <= norm(amat(B))_"F"
$
  so convergence in $epsilon$ implies convergence in the operator norm; the Frobenius-based
  metric is a conservative measure of operator agreement
- the convergence tables report the condition number of each solver's dense system matrix
  $amat(A)$: the EPGP weight-space matrix
  $amat(A) = amat(W)^(-1) + amat(Phi) amat(Phi)^herm \/ sigma_"n"^2$ and the BEM Galerkin
  single-layer matrix
- the EPGP operator is the mean of a Gaussian posterior with covariance $amat(Sigma)$
- the per-receiver posterior standard deviation $sigma_i = sqrt(amat(Sigma)_(i i))$ depends on
  the receiver only, not on the transmitter
- the total relative uncertainty aggregates these over the operator
$
  eta := sqrt(M sum_i sigma_i^2) / norm(amat(T)_"ref")
$
  with $M$ the operator dimension; $eta$ is the expected relative Frobenius deviation of the
  operator from its posterior mean

#pagebreak(weak: true)
== Spherical Cavity

- PEC sphere of radius $R = 4$, same interior surface $Lambda$, wavenumber $k = 2$
- the spherical case admits a closed-form reaction operator $amat(T)_star$ of unlimited
  accuracy, which serves as ground truth for both solvers
- the reaction operator $amat(T)$ shares the same structure for both solvers
- reciprocity makes it symmetric, $amat(T) = amat(T)^transp$, and it is diagonal-dominant: the
  reaction is largest when transmitter and receiver coincide and decays with their separation
- the $M = 64$ configurations come from $32$ surface points each carrying two tangential
  polarizations, so consecutive index pairs share a $Lambda$ point

=== BEM

==== Convergence

#figure(
  image("../../res/bem_sphere_convergence.svg"),
  caption: [BEM convergence on the spherical cavity versus analytic reference.],
)

=== EPGP

==== Field

#figure(
  grid(
    columns: 1,
    row-gutter: 6pt,
    image("../../res/epgp_sphere_field_real.png"),
    image("../../res/epgp_sphere_field_lic.png"),
  ),
  caption: [EPGP scattered field on a 2D spherical cavity slice.],
)

- @fig:sphere-field-std maps the posterior standard deviation of the scattered field over the
  same slice

#figure(
  image("../../res/epgp_sphere_field_std.png", width: 60%),
  caption: [EPGP scattered-field uncertainty on the spherical cavity slice.],
) <fig:sphere-field-std>

==== Operator

#figure(
  image("../../res/sphere_uq_operator.png"),
  caption: [Reaction operator $|amat(T)|$ and posterior uncertainty $sigma$, spherical cavity.],
)

- $sigma$ depends only on the receiver, not the transmitter (uniform along the transmitter axis), since the posterior covariance is shared across excitations
- spherical symmetry makes all receivers equivalent, so $sigma$ is uniform

==== Convergence

#figure(
  image("../../res/epgp_sphere_convergence.svg", width: 68%),
  caption: [EPGP convergence on the spherical cavity versus analytic reference.],
)

==== Noise Influence

#figure(
  image("../../res/sphere_noise.svg", width: 68%),
  caption: [Reconstruction error and predicted uncertainty vs assumed noise, spherical cavity.],
)

- more assumed noise, stronger regularization: error and uncertainty both grow

=== Comparison

- both solvers reproduce the analytic operator $amat(T)_star$ to high accuracy

==== Cross-Validation

- EPGP and BEM agree with each other to $approx 10^(-10)$ on the sphere
- since both were just certified against the analytic $amat(T)_star$, this agreement validates
  solver-vs-solver comparison itself as a correctness check, the check the ellipsoidal cavity must
  rely on for lack of an analytic reference

==== Accuracy--Runtime Trade-off

#figure(
  image("../../res/pareto_sphere.svg"),
  caption: [Accuracy vs wall time for BEM and EPGP on the spherical cavity.],
)

- faint points are all grid runs; the solid line is each solver's Pareto front, the non-dominated
  (wall time, error) points
- EPGP forms a near-vertical front: accuracy improves by many orders of magnitude at nearly fixed
  wall time ($approx 5$ to $20$ s), since the cost is dominated by the fixed factorization and raising
  $N_s$ adds little time in this range
- BEM is a staircase: each decade of accuracy costs roughly an order of magnitude more wall time,
  reflecting the dense $cal(O)(N^3)$ factorization
- the fronts cross: at loose accuracy ($epsilon gt.tilde 10^(-5)$) BEM is cheaper, but for any
  demanding accuracy EPGP dominates, reaching $epsilon approx 10^(-9)$ in $approx 10$ s where BEM
  needs tens to hundreds of seconds
- BEM ultimately reaches the lowest reference error ($epsilon approx 10^(-11)$) only at $approx 500$ s,
  whereas EPGP drives reciprocity to $rho approx 10^(-12)$ already at $approx 17$ s

#page(flipped: true, margin: 1.3cm)[
  #set table(inset: (x: 6pt, y: 5pt))

  #let labelbox(n) = (
    table.vline(x: 0, stroke: 1.5pt),
    table.vline(x: 1, stroke: 1.5pt),
    ..range(n + 1).map(y => table.hline(y: y, end: 1, stroke: 1.5pt)),
  )

  #figure(
    text(size: 8pt)[#table(
      columns: (auto,) + (1fr,) * sphere-runs.len(),
      align: right,
      stroke: 0.5pt,
      ..labelbox(7),
      [$N_s$],          ..sphere-runs.map(r => [#r.at(0)]),
      [features],       ..sphere-runs.map(r => [#r.at(2)]),
      [mem [GiB]],      ..sphere-runs.map(r => if float(r.at(4)) > 0 { [#calc.round(float(r.at(4)) / 1048576.0, digits: 1)] } else { [---] }),
      [$t$ [s]],        ..sphere-runs.map(r => [#r.at(3)]),
      [cond $amat(A)$], ..sphere-runs.map(r => sci(r.at(5))),
      [$rho$],          ..sphere-runs.map(r => sci(r.at(7))),
      [$epsilon$],      ..sphere-runs.map(r => sci(r.at(8))),
    )],
    caption: [EPGP convergence on the spherical cavity ($N_b = #_sphere-nb-max$).],
  )

  #v(2em)

  #figure(
    text(size: 8pt)[#table(
      columns: (auto,) + (1fr,) * bem-sphere-runs.len(),
      align: right,
      stroke: 0.5pt,
      ..labelbox(8),
      [$p$],            ..bem-sphere-runs.map(r => [#r.at(0)]),
      [$m$],            ..bem-sphere-runs.map(r => [#r.at(1)]),
      [DOFs],           ..bem-sphere-runs.map(r => [#r.at(2)]),
      [mem [GiB]],      ..bem-sphere-runs.map(r => if float(r.at(4)) > 0 { [#calc.round(float(r.at(4)) / 1048576.0, digits: 1)] } else { [---] }),
      [$t$ [s]],        ..bem-sphere-runs.map(r => [#r.at(3)]),
      [cond $amat(A)$], ..bem-sphere-runs.map(r => sci(r.at(5))),
      [$rho$],          ..bem-sphere-runs.map(r => sci(r.at(7))),
      [$epsilon$],      ..bem-sphere-runs.map(r => sci(r.at(8))),
    )],
    caption: [BEM convergence on the spherical cavity.],
  )
]

#pagebreak(weak: true)
== Ellipsoidal Cavity

- ellipsoidal cavity with semi-axes $(4, 4, 6)$, same interior surface $Lambda$, wavenumber $k = 2$
- no analytic operator is available, so the high-fidelity BEM solution serves as the reference
- the operator shares the same structure as the spherical case: symmetric and diagonal-dominant

=== BEM

==== Convergence

- runs over a $p times m$ grid
- analytic boundary, so $h$ converges algebraically and $p$ geometrically
- best grid run p5/m4 ($4800$ DOFs) reaches $rho approx 1.4 times 10^(-10)$
- the BEM reference $amat(T)_"BEM"$ is a dedicated off-grid run at p6/m4 ($5292$ DOFs,
  $rho approx 2.5 times 10^(-10)$)
- $k = 2$ lies $approx 0.0015$ above an interior resonance near $1.9985$; the effect on
  conditioning is mild and both solvers converge cleanly, so $k = 2$ is operationally non-resonant

#figure(
  image("../../res/bem_ellipse_convergence.svg"),
  caption: [BEM reciprocity error on the ellipsoidal cavity.],
)

=== EPGP

==== Field

#figure(
  grid(
    columns: 1,
    row-gutter: 6pt,
    image("../../res/epgp_ellipse_field_real.png"),
    image("../../res/epgp_ellipse_field_lic.png"),
  ),
  caption: [EPGP scattered field on a 2D ellipsoidal cavity slice.],
)

- @fig:ellipse-field-std maps the posterior standard deviation of the scattered field over the
  same slice

#figure(
  image("../../res/epgp_ellipse_field_std.png", width: 60%),
  caption: [EPGP scattered-field uncertainty on the ellipsoidal cavity slice.],
) <fig:ellipse-field-std>

==== Operator

#figure(
  image("../../res/ellipse_uq_operator.png"),
  caption: [Reaction operator $|amat(T)|$ and posterior uncertainty $sigma$, ellipsoidal cavity.],
)

- $sigma$ no longer uniform: it grows for receivers deeper inside the cavity, away from the boundary (toward the elongated $z$-axis)
- intuition: boundary data constrains near-wall receivers more tightly than deep-interior ones

==== Convergence

- $rho$ decreases with $N_s$ and floors at $approx 3 times 10^(-11)$, below the BEM reference floor

#figure(
  image("../../res/epgp_ellipse_convergence.svg", width: 68%),
  caption: [EPGP reciprocity error on the ellipsoidal cavity versus $N_s$.],
)

==== Noise Influence

#figure(
  image("../../res/ellipse_noise.svg", width: 68%),
  caption: [Reconstruction error and predicted uncertainty vs assumed noise, ellipsoidal cavity.],
)

- same trend as the sphere; error measured against the BEM reference

=== Comparison

- with no analytic ground truth, the two solvers are validated against each other

==== Cross-Validation

- a high-fidelity BEM solution is the reference, off the convergence grid, from a dedicated finer run
- reference error $epsilon$ against the BEM reference operator decreases monotonically, reaching
  $approx 1.3 times 10^(-8)$ at $N_s = 1024$
- $epsilon$ is still decreasing at $N_s = 1024$, so it is an upper bound, not converged
- both reciprocity floors ($ap 1 times 10^(-10)$ BEM, $ap 3 times 10^(-11)$ EPGP) lie well below
  $epsilon$, so the residual is genuine discretization difference, not round-off
- the EPGP operator is itself accurate to $10^(-9)$, so the ellipsoidal residual is set by the
  finite BEM mesh; the cross-validation understates the EPGP accuracy

==== Accuracy--Runtime Trade-off

#figure(
  image("../../res/pareto_ellipse.svg"),
  caption: [Reciprocity error vs wall time for BEM and EPGP on the ellipsoidal cavity.],
)

- same qualitative picture as the sphere: EPGP a near-vertical front at $approx 6$ to $18$ s, BEM a
  staircase descending only with large wall-time increases
- BEM's deep end is even more expensive here, reaching $rho approx 10^(-10)$ only at $approx 1700$ s
  (the p6/m4 reference run)
- EPGP reaches $rho approx 10^(-9)$ to $10^(-10)$ at $approx 10$ s, two to three orders of magnitude
  faster than BEM at equal accuracy
- BEM is cheaper only at loose tolerance; for any demanding accuracy EPGP is the cheaper solver, and
  on the more realistic geometry the gap is wider than on the sphere

#page(flipped: true, margin: 1.3cm)[
  #set table(inset: (x: 6pt, y: 5pt))

  #let labelbox(n) = (
    table.vline(x: 0, stroke: 1.5pt),
    table.vline(x: 1, stroke: 1.5pt),
    ..range(n + 1).map(y => table.hline(y: y, end: 1, stroke: 1.5pt)),
  )

  #figure(
    text(size: 8pt)[#table(
      columns: (auto,) + (1fr,) * bem-runs.len(),
      align: right,
      stroke: 0.5pt,
      ..labelbox(7),
      [$p$],            ..bem-runs.map(r => [#r.at(0)]),
      [$m$],            ..bem-runs.map(r => [#r.at(1)]),
      [DOFs],           ..bem-runs.map(r => [#r.at(2)]),
      [mem [GiB]],      ..bem-runs.map(r => if float(r.at(4)) > 0 { [#calc.round(float(r.at(4)) / 1048576.0, digits: 1)] } else { [---] }),
      [$t$ [s]],        ..bem-runs.map(r => [#r.at(3)]),
      [cond $amat(A)$], ..bem-runs.map(r => sci(r.at(5))),
      [$rho$],          ..bem-runs.map(r => sci(r.at(7))),
    )],
    caption: [BEM convergence on the ellipsoidal cavity.],
  )

  #v(2em)

  #figure(
    text(size: 8pt)[#table(
      columns: (auto,) + (1fr,) * epgp-runs.len(),
      align: right,
      stroke: 0.5pt,
      ..labelbox(7),
      [$N_s$],          ..epgp-runs.map(r => [#r.at(0)]),
      [features],       ..epgp-runs.map(r => [#r.at(2)]),
      [$t$ [s]],        ..epgp-runs.map(r => [#r.at(3)]),
      [mem [GiB]],      ..epgp-runs.map(r => if float(r.at(4)) > 0 { [#calc.round(float(r.at(4)) / 1048576.0, digits: 1)] } else { [---] }),
      [cond $amat(A)$], ..epgp-runs.map(r => sci(r.at(5))),
      [$rho$],          ..epgp-runs.map(r => sci(r.at(7))),
      [$epsilon$],      ..epgp-runs.map(r => sci(r.at(8))),
    )],
    caption: [EPGP convergence on the ellipsoidal cavity ($N_b = #_epgp-nb-max$).],
  )
]
