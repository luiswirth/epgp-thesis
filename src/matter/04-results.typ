#import "../setup-math.typ": *

#let bem-runs = csv("../../res/ellipse_bem_results.csv").slice(1).sorted(
  key: r => (int(r.at(0)), int(r.at(1)))
)
#let _epgp-all = csv("../../res/ellipse_epgp_results.csv").slice(1)
#let _epgp-nb-max = calc.max(.._epgp-all.map(r => int(r.at(1))))
#let epgp-runs = _epgp-all.filter(r => int(r.at(1)) == _epgp-nb-max).sorted(
  key: r => int(r.at(0))
)

= Results and Discussion

- we present results for two cavity geometries
- on the spherical cavity, the analytic operator $amat(T)_star$ is available; each solver
  is validated independently against it, establishing that both are correct
- on the ellipsoidal cavity, no analytic solution exists; the two solvers are cross-validated
  against each other, with the sphere results as prior evidence of their reliability
- each geometry section covers the EPGP solver, the BEM solver, and (for the ellipsoid)
  a direct comparison between the two

- two relative error measures are used throughout
  - the *reciprocity error* $rho$ is reference-free: reciprocity forces the true $amat(T)$
    to be symmetric; $rho$ measures the violation
  - the *reference error* $epsilon$ is the distance to a trusted reference operator
$
  rho := norm(amat(T) - amat(T)^transp) / norm(amat(T)) quad quad
  epsilon := norm(amat(T) - amat(T)_"ref") / norm(amat(T)_"ref")
$
- $amat(T)_"ref"$ is the analytic $amat(T)_star$ for the spherical cavity and the
  high-fidelity BEM operator $amat(T)_"BEM"$ for the ellipsoidal cavity
- the operator norm is bounded above by the Frobenius norm,
$
  norm(amat(B))_"op" <= norm(amat(B))_"F"
$
  so convergence in $epsilon$ implies convergence in the operator norm; the Frobenius-based
  metric is a conservative measure of operator agreement
- in both geometries, $amat(T)$ is symmetric ($amat(T) = amat(T)^transp$) and diagonal-dominant:
  the reaction is largest when transmitter and receiver coincide and decays with their separation
- the $M = 64$ configurations come from $32$ surface points each carrying two tangential
  polarizations, so consecutive index pairs share a $Lambda$ point

#pagebreak(weak: true)
== Spherical Cavity

- PEC sphere of radius $R = 4$, same interior surface $Lambda$, wavenumber $k = 2$
- the spherical case admits a closed-form reaction operator $amat(T)_star$ of unlimited
  accuracy, which serves as ground truth for both solvers

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

- the spherical symmetry is clearly visible: the field is rotationally symmetric about the
  dipole axis, with concentric wavefronts and uniform LIC streamlines; this simple structure
  is absent in the ellipsoidal case, where the broken symmetry produces a richer, less regular field

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

- the per-receiver posterior standard deviation $sigma_i = sqrt(amat(Sigma)_(i i))$ depends
  on the receiver only, not on the transmitter, since the posterior covariance is shared
  across all excitations
- spherical symmetry makes all receivers equivalent, so $sigma$ is uniform; this uniformity
  is absent on the ellipsoid, where the elongated geometry breaks the receiver equivalence

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

=== BEM

==== Convergence

#figure(
  image("../../res/bem_sphere_convergence.svg"),
  caption: [BEM convergence on the spherical cavity versus analytic reference.],
)

#pagebreak(weak: true)
== Ellipsoidal Cavity

- ellipsoidal cavity with semi-axes $(4, 4, 6)$, same interior surface $Lambda$, wavenumber $k = 2$
- no analytic operator is available: the ellipsoid does not separate the vector Helmholtz
  equation in any standard coordinate system, so no closed-form eigenfunction expansion exists;
  the high-fidelity BEM solution serves as the reference

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

- the broken symmetry of the ellipsoid is clearly visible: the field is no longer rotationally
  symmetric, and the LIC streamlines reflect the more complex interior geometry

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

=== Comparison

==== Cross-Validation

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

- faint points are all grid runs; the solid line is each solver's Pareto front
- EPGP forms a near-vertical front at $approx 6$ to $18$ s: accuracy improves by orders of
  magnitude at nearly fixed wall time, since the cost is dominated by the fixed factorization
- BEM is a staircase descending only with large wall-time increases, reaching
  $rho approx 10^(-10)$ only at $approx 1700$ s (the p6/m4 reference run)
- EPGP reaches $rho approx 10^(-9)$ to $10^(-10)$ at $approx 10$ s, two to three orders of
  magnitude faster than BEM at equal accuracy
- BEM is cheaper only at loose tolerance; for any demanding accuracy EPGP is the cheaper solver

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
