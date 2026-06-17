#import "../setup-math.typ": *

#let bem-runs = csv("../../res/ellipse_bem_results.csv").slice(1).sorted(
  key: r => (int(r.at(0)), int(r.at(1)))
)
#let epgp-runs = csv("../../res/ellipse_epgp_results.csv").slice(1).sorted(
  key: r => int(r.at(0))
)
#let sphere-runs = csv("../../res/sphere_epgp_results.csv").slice(1).sorted(
  key: r => int(r.at(0))
)

= Results and Discussion <sec:results>


Two benchmarks are reported.
- The spherical cavity (@sec:res-sphere) has a closed-form reaction operator, so
  the EPGP operator is measured directly against an exact reference.
- The ellipsoidal cavity (@sec:res-ellipse) has no closed form, so the EPGP
  operator is instead cross-validated against an independent BEM solve.

There are three relative error measures that we will be using throughout.
All of them are a Frobenius-norm operator difference normalized by some baseline.
- The *reciprocity error* $rho$ is reference-free: transmitters and receivers
  coincide on $Lambda$, so reciprocity forces the true $amat(T)$ to be symmetric
  and $rho$ measures the violation or asymmetry, necessary but not sufficient for accuracy.
- The *reference error* $epsilon$ is the distance to a trusted reference operator.
- The *self-convergence error* $delta$ uses the highest-fidelity run
  $amat(T)_"fin"$ of an operator's own family of operators and measures settling
  of a sequence, not accuracy.
$
  rho := norm(amat(T) - amat(T)^transp) / norm(amat(T)) quad quad
  epsilon := norm(amat(T)_"EPGP" - amat(T)_"ref") / norm(amat(T)_"ref") quad quad
  delta := norm(amat(T) - amat(T)_"fin") / norm(amat(T)_"fin")
$ <eq:errors>

NOTE: Reciprocity is symmetric by Galerkin construction...
Use instead the self-convergence error!


#pagebreak(weak: true)
== Analytic Spherical Cavity <sec:res-sphere>

Analytic reference operator $amat(T)_star$ derived in @sec:sphere.
Unlimited accuracy.
PEC sphere of radius $R = 4$, same interior surface $Lambda$, wavenumber $k = 2$.


#figure(
  grid(
    columns: 1,
    row-gutter: 6pt,
    image("../../res/sphere_epgp_field_real.png"),
    image("../../res/sphere_epgp_field_lic.png"),
  ),
  caption: [EPGP scattered field on a $2"D"$ spherical cavity slice.],
)

The EPGP operator is accurate to the $10^(-9)$ level.

#figure(
  image("../../res/sphere_epgp_convergence.svg", width: 68%),
  caption: [EPGP convergence on spherical cavity versus $n_"spec"$.],
) <fig:sphere-convergence>


#pagebreak(weak: true)
== Ellipsoidal Cavity <sec:res-ellipse>



#figure(
  grid(
    columns: 1,
    row-gutter: 6pt,
    image("../../res/ellipse_epgp_field_real.png"),
    image("../../res/ellipse_epgp_field_lic.png"),
  ),
  caption: [EPGP scattered field on a $2"D"$ ellipsoidal cavity slice.],
)

Total field is a standing wave (static).
Incident and scattered fields carry power (dynamic).

=== BEM Reference Solution <sec:res-bem>

Runs over a $p times m$ grid.
Analytic boundary, so $h$ converges algebraically and $p$ geometrically.

Best run p5m4 ($4800$ DOFs) reaches $rho approx 1.4 times 10^(-10)$.
This is the reference $amat(T)_"BEM"$.

#figure(
  image("../../res/ellipse_bem_convergence.svg"),
  caption: [BEM reciprocity error.],
) <fig:bem-convergence>



=== EPGP Reconstruction <sec:res-epgp>

$rho$ decreases with $n_"spec"$ and floors at $approx 7 times 10^(-10)$, close to
the BEM reference floor.

=== Cross-Validation <sec:res-comparison>

Reference error $epsilon$ against the p5m4 BEM operator.
$epsilon$ decreases monotonically, reaching $approx 5.6 times 10^(-8)$ at $n_"spec" = 1024$.

#figure(
  image("../../res/ellipse_epgp_convergence.svg", width: 68%),
  caption: [EPGP convergence on the ellipsoid versus $n_"spec"$.],
) <fig:ellipse-conv>

- $epsilon$ is still decreasing at $n_"spec" = 1024$, so it is an upper bound,
  not converged.
- Both reciprocity floors ($ap 2 times 10^(-9)$ BEM, $ap 7 times 10^(-10)$ EPGP)
  lie well below $epsilon$, so the residual is genuine discretization difference,
  not round-off.
- The EPGP operator is itself accurate to $10^(-9)$, so the ellipsoidal residual
  is set by the finite BEM mesh; the cross-validation understates the EPGP
  accuracy.

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
      ..labelbox(8),
      [$n_"spec"$], ..sphere-runs.map(r => [#r.at(0)]),
      [DOFs], ..sphere-runs.map(r => [#r.at(1)]),
      [$t$ [s]], ..sphere-runs.map(r => [#calc.round(float(r.at(2)), digits: 1)]),
      [cond $amat(A)$], ..sphere-runs.map(r => sci(r.at(4))),
      [$rho$], ..sphere-runs.map(r => sci(r.at(5))),
      [$delta$], ..sphere-runs.map(r => if float(r.at(6)) == 0 { [---] } else { sci(r.at(6)) }),
      [$epsilon_star$], ..sphere-runs.map(r => sci(r.at(7))),
      [mem [GiB]], ..sphere-runs.map(r => if r.len() > 8 and float(r.at(8)) > 0 { [#calc.round(float(r.at(8)) / 1048576.0, digits: 1)] } else { [---] }),
    )],
    caption: [EPGP convergence on the spherical cavity.],
  ) <tab:sphere>

  #v(2em)

  #figure(
    text(size: 8pt)[#table(
      columns: (auto,) + (1fr,) * bem-runs.len(),
      align: right,
      stroke: 0.5pt,
      ..labelbox(7),
      [$p$], ..bem-runs.map(r => [#r.at(0)]),
      [$m$], ..bem-runs.map(r => [#r.at(1)]),
      [DOFs], ..bem-runs.map(r => [#r.at(2)]),
      [$rho$], ..bem-runs.map(r => sci(r.at(3))),
      [$delta$], ..bem-runs.map(r => if float(r.at(4)) == 0 { [---] } else { sci(r.at(4)) }),
      [$t$ [s]], ..bem-runs.map(r => [#r.at(5)]),
      [mem [GiB]], ..bem-runs.map(r => if r.len() > 6 and float(r.at(6)) > 0 { [#calc.round(float(r.at(6)) / 1048576.0, digits: 1)] } else { [---] }),
    )],
    caption: [BEM convergence on the ellipsoidal cavity.],
  ) <tab:bem>

  #v(2em)

  #figure(
    text(size: 8pt)[#table(
      columns: (auto,) + (1fr,) * epgp-runs.len(),
      align: right,
      stroke: 0.5pt,
      ..labelbox(8),
      [$n_"spec"$], ..epgp-runs.map(r => [#r.at(0)]),
      [DOFs], ..epgp-runs.map(r => [#r.at(1)]),
      [$t$ [s]], ..epgp-runs.map(r => [#calc.round(float(r.at(2)), digits: 1)]),
      [cond $amat(A)$], ..epgp-runs.map(r => sci(r.at(4))),
      [$rho$], ..epgp-runs.map(r => sci(r.at(5))),
      [$delta$], ..epgp-runs.map(r => if float(r.at(6)) == 0 { [---] } else { sci(r.at(6)) }),
      [$epsilon$], ..epgp-runs.map(r => sci(r.at(7))),
      [mem [GiB]], ..epgp-runs.map(r => if r.len() > 8 and float(r.at(8)) > 0 { [#calc.round(float(r.at(8)) / 1048576.0, digits: 1)] } else { [---] }),
    )],
    caption: [EPGP convergence on the ellipsoidal cavity.],
  ) <tab:epgp>
]


