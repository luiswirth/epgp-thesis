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

= Results and Discussion <sec:results>

There are two relative error measures used throughout.
Both are Frobenius-norm operator differences normalized by the reference.
- The *reciprocity error* $rho$ is reference-free: transmitters and receivers
  coincide on $Lambda$, so reciprocity forces the true $amat(T)$ to be symmetric
  and $rho$ measures the violation, a necessary but not sufficient condition for accuracy.
- The *reference error* $epsilon$ is the distance to a trusted reference operator.
$
  rho := norm(amat(T) - amat(T)^transp) / norm(amat(T)) quad quad
  epsilon := norm(amat(T) - amat(T)_"ref") / norm(amat(T)_"ref")
$ <eq:errors>

The EPGP operator is the mean of a Gaussian posterior with covariance
$amat(Sigma)$. The per-receiver posterior standard deviation is
$sigma_i = sqrt(amat(Sigma)_(i i))$, which depends on the receiver only, not on
the transmitter. The total relative uncertainty aggregates these over the operator
$
  eta := sqrt(M sum_i sigma_i^2) / norm(amat(T)_"ref")
$ <eq:uncertainty>
where $M$ is the operator dimension; $eta$ is the expected relative Frobenius
deviation of the operator from its posterior mean.

#pagebreak(weak: true)
== Analytic Spherical Cavity <sec:res-sphere>

Analytic reference operator $amat(T)_star$.
Unlimited accuracy.
PEC sphere of radius $R = 4$, same interior surface $Lambda$, wavenumber $k = 2$.

=== Field <sec:res-sphere-field>

#figure(
  grid(
    columns: 1,
    row-gutter: 6pt,
    image("../../res/epgp_sphere_field_real.png"),
    image("../../res/epgp_sphere_field_lic.png"),
  ),
  caption: [EPGP scattered field on a 2D spherical cavity slice.],
)

@fig:sphere-field-std maps the posterior standard deviation of the scattered
field over the same slice.

#figure(
  image("../../res/epgp_sphere_field_std.png", width: 60%),
  caption: [EPGP scattered-field uncertainty on the spherical cavity slice.],
) <fig:sphere-field-std>

=== Operator <sec:res-sphere-operator>

#figure(
  image("../../res/sphere_uq_operator.png"),
  caption: [Reaction operator $|amat(T)|$ and posterior uncertainty $sigma$, spherical cavity.],
) <fig:sphere-operator>

// notes (rewrite into prose):
- $amat(T)$ symmetric (reciprocity), $amat(T) = amat(T)^transp$
- diagonal-dominant: largest reaction when transmitter and receiver coincide, decaying with separation
- $M = 64$ configs: each of 32 surface points carries two tangential polarizations, so consecutive index pairs share a $Lambda$ point
- $sigma$ depends only on the receiver, not the transmitter (uniform along the transmitter axis), since the posterior covariance is shared across excitations
- spherical symmetry makes all receivers equivalent, so $sigma$ is uniform

==== Noise Influence <sec:res-sphere-noise>

#figure(
  image("../../res/sphere_noise.svg", width: 68%),
  caption: [Reconstruction error and predicted uncertainty vs assumed noise, spherical cavity.],
) <fig:sphere-noise>

// notes (rewrite into prose):
- more assumed noise, stronger regularization: error and uncertainty both grow

==== Convergence (BEM) <sec:res-sphere-bem>

#figure(
  image("../../res/bem_sphere_convergence.svg"),
  caption: [BEM convergence on the spherical cavity versus analytic reference.],
) <fig:sphere-bem-convergence>

==== Convergence (EPGP) <sec:res-sphere-epgp>

#figure(
  image("../../res/epgp_sphere_convergence.svg", width: 68%),
  caption: [EPGP convergence on the spherical cavity versus analytic reference.],
) <fig:sphere-epgp-convergence>

==== Accuracy--Runtime Trade-off <sec:res-sphere-pareto>

#figure(
  image("../../res/pareto_sphere.svg"),
  caption: [Accuracy vs wall time for BEM and EPGP on the spherical cavity.],
) <fig:pareto-sphere>

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
      [DOFs],           ..sphere-runs.map(r => [#r.at(2)]),
      [mem [GiB]],      ..sphere-runs.map(r => if float(r.at(4)) > 0 { [#calc.round(float(r.at(4)) / 1048576.0, digits: 1)] } else { [---] }),
      [$t$ [s]],        ..sphere-runs.map(r => [#r.at(3)]),
      [cond $amat(A)$], ..sphere-runs.map(r => sci(r.at(5))),
      [$rho$],          ..sphere-runs.map(r => sci(r.at(7))),
      [$epsilon$],      ..sphere-runs.map(r => sci(r.at(8))),
    )],
    caption: [EPGP convergence on the spherical cavity ($N_b = #_sphere-nb-max$).],
  ) <tab:sphere>

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
  ) <tab:sphere-bem>
]

#pagebreak(weak: true)
== Ellipsoidal Cavity <sec:res-ellipse>

=== Field <sec:res-ellipse-field>

#figure(
  grid(
    columns: 1,
    row-gutter: 6pt,
    image("../../res/epgp_ellipse_field_real.png"),
    image("../../res/epgp_ellipse_field_lic.png"),
  ),
  caption: [EPGP scattered field on a 2D ellipsoidal cavity slice.],
)

Total field is a standing wave (static).
Incident and scattered fields carry power (dynamic).

@fig:ellipse-field-std maps the posterior standard deviation of the scattered
field over the same slice.

#figure(
  image("../../res/epgp_ellipse_field_std.png", width: 60%),
  caption: [EPGP scattered-field uncertainty on the ellipsoidal cavity slice.],
) <fig:ellipse-field-std>

=== Operator <sec:res-ellipse-operator>

#figure(
  image("../../res/ellipse_uq_operator.png"),
  caption: [Reaction operator $|amat(T)|$ and posterior uncertainty $sigma$, ellipsoidal cavity.],
) <fig:ellipse-operator>

// notes (rewrite into prose):
- same structure as the sphere: $amat(T)$ symmetric and diagonal-dominant
- $sigma$ no longer uniform: it grows for receivers deeper inside the cavity, away from the boundary (toward the elongated $z$-axis)
- intuition: boundary data constrains near-wall receivers more tightly than deep-interior ones

==== Noise Influence <sec:res-ellipse-noise>

#figure(
  image("../../res/ellipse_noise.svg", width: 68%),
  caption: [Reconstruction error and predicted uncertainty vs assumed noise, ellipsoidal cavity.],
) <fig:ellipse-noise>

// notes (rewrite into prose):
- same trend as the sphere; error measured against the BEM reference

==== BEM Reference Solution <sec:res-bem>

Runs over a $p times m$ grid.
Analytic boundary, so $h$ converges algebraically and $p$ geometrically.

Best grid run p5/m4 ($4800$ DOFs) reaches $rho approx 1.4 times 10^(-10)$.
The BEM reference $amat(T)_"BEM"$ is a dedicated off-grid run at p6/m4 ($5292$ DOFs, $rho approx 2.5 times 10^(-10)$).

#figure(
  image("../../res/bem_ellipse_convergence.svg"),
  caption: [BEM reciprocity error on the ellipsoidal cavity.],
) <fig:bem-convergence>

==== EPGP Reconstruction <sec:res-epgp>

$rho$ decreases with $N_s$ and floors at $approx 3 times 10^(-11)$, below the
BEM reference floor.

#figure(
  image("../../res/epgp_ellipse_convergence.svg", width: 68%),
  caption: [EPGP reciprocity error on the ellipsoidal cavity versus $N_s$.],
) <fig:ellipse-conv>

==== Cross-Validation <sec:res-comparison>

We use a high-fidelity BEM solution as reference to benchmark the EPGP.
The reference is off the convergence grid, produced by a dedicated finer run.

Reference error $epsilon$ against the BEM reference operator.
$epsilon$ decreases monotonically, reaching $approx 1.3 times 10^(-8)$ at $N_s = 1024$.

- $epsilon$ is still decreasing at $N_s = 1024$, so it is an upper bound, not converged.
- Both reciprocity floors ($ap 1 times 10^(-10)$ BEM, $ap 3 times 10^(-11)$ EPGP)
  lie well below $epsilon$, so the residual is genuine discretization difference, not round-off.
- The EPGP operator is itself accurate to $10^(-9)$, so the ellipsoidal residual
  is set by the finite BEM mesh; the cross-validation understates the EPGP accuracy.

==== Accuracy--Runtime Trade-off <sec:res-ellipse-pareto>

#figure(
  image("../../res/pareto_ellipse.svg"),
  caption: [Reciprocity error vs wall time for BEM and EPGP on the ellipsoidal cavity.],
) <fig:pareto-ellipse>

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
  ) <tab:bem>

  #v(2em)

  #figure(
    text(size: 8pt)[#table(
      columns: (auto,) + (1fr,) * epgp-runs.len(),
      align: right,
      stroke: 0.5pt,
      ..labelbox(7),
      [$N_s$],          ..epgp-runs.map(r => [#r.at(0)]),
      [DOFs],           ..epgp-runs.map(r => [#r.at(2)]),
      [$t$ [s]],        ..epgp-runs.map(r => [#r.at(3)]),
      [mem [GiB]],      ..epgp-runs.map(r => if float(r.at(4)) > 0 { [#calc.round(float(r.at(4)) / 1048576.0, digits: 1)] } else { [---] }),
      [cond $amat(A)$], ..epgp-runs.map(r => sci(r.at(5))),
      [$rho$],          ..epgp-runs.map(r => sci(r.at(7))),
      [$epsilon$],      ..epgp-runs.map(r => sci(r.at(8))),
    )],
    caption: [EPGP convergence on the ellipsoidal cavity ($N_b = #_epgp-nb-max$).],
  ) <tab:epgp>
]
