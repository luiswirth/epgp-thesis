#import "../setup-math.typ": *

#let bem-runs = csv("../../res/bem_results.csv").slice(1).sorted(
  key: r => (int(r.at(0)), int(r.at(1)))
)
#let epgp-runs = csv("../../res/epgp_results.csv").slice(1).sorted(
  key: r => int(r.at(0))
)
#let sphere-runs = csv("../../res/sphere_results.csv").slice(1).sorted(
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


#pagebreak(weak: true)
== Analytic Spherical Cavity <sec:res-sphere>

Analytic reference operator $amat(T)_star$ derived in @sec:sphere.
Unlimited accuracy.
PEC sphere of radius $R = 4$, same interior surface $Lambda$, wavenumber $k = 2$.


#figure(
  grid(
    columns: 1,
    row-gutter: 6pt,
    image("../../res/sphere_field_real.png"),
    image("../../res/sphere_field_lic.png"),
  ),
  caption: [EPGP scattered field on a $2"D"$ spherical cavity slice.],
)

The EPGP operator is accurate to the $10^(-9)$ level.

#figure(
  image("../../res/sphere_convergence.svg", width: 68%),
  caption: [EPGP convergence on spherical cavity.],
) <fig:sphere-convergence>


#pagebreak(weak: true)
== Ellipsoidal Cavity <sec:res-ellipse>

No closed-form operator.
We need a numerical reference solution.
The accuracy is established by agreement of two unrelated solvers.

We use the Boundary Element Method (BEM) to compute a reference.
BEMBEL library.

#figure(
  grid(
    columns: 1,
    row-gutter: 6pt,
    image("../../res/field_real.png"),
    image("../../res/field_lic.png"),
  ),
  caption: [EPGP scattered field on a $2"D"$ ellipsoidal cavity slice.],
)

=== BEM Reference Solution <sec:res-bem>

Indirect single-layer formulation of @sec:impl, assembled over a $p times m$ grid:
mesh $h$-refinement level $m$ and polynomial $p$-refinement,

Analytic boundary, so $h$ converges algebraically and $p$ geometrically.

Best run p4m4 ($4332$ DOFs) reaches $rho approx 2.0 times 10^(-9)$, near the dense-solver floor.
This is the reference $amat(T)_"BEM"$.

#figure(
  image("../../res/bem_convergence.svg"),
  caption: [BEM reciprocity error.],
) <fig:bem-convergence>

posterior-mean scattered field on a 2D slice (real part + LIC of field
lines), smooth and artefact-free. Scattered field carries power; total field is a
standing wave (lossless PEC, no net power flow), real up to global phase.


=== EPGP Reconstruction <sec:res-epgp>

Condition the Maxwell plane-wave GP prior on the tangential-trace data, evaluate
posterior-mean scattered field on $Lambda$.
Single knob: $n_"spec"$, the number of spectral directions on the Fibonacci sphere.

$rho$ decreases with $n_"spec"$ and floors at $approx 7 times 10^(-10)$,
below the BEM floor.

=== Cross-Validation <sec:res-comparison>

Reference error $epsilon$ against the p4m4 BEM operator.
$epsilon$ decreases monotonically, reaching $approx 6.7 times 10^(-8)$ at $n_"spec" = 1024$.

#figure(
  image("../../res/ellipse_convergence.svg", width: 68%),
  caption: [EPGP convergence on the ellipsoid.],
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
      ..labelbox(7),
      [$n_"spec"$], ..sphere-runs.map(r => [#r.at(0)]),
      [DOFs], ..sphere-runs.map(r => [#r.at(1)]),
      [$t$ [s]], ..sphere-runs.map(r => [#calc.round(float(r.at(2)), digits: 1)]),
      [cond $amat(A)$], ..sphere-runs.map(r => sci(r.at(4))),
      [$rho$], ..sphere-runs.map(r => sci(r.at(5))),
      [$delta$], ..sphere-runs.map(r => if float(r.at(6)) == 0 { [---] } else { sci(r.at(6)) }),
      [$epsilon_star$], ..sphere-runs.map(r => sci(r.at(7))),
    )],
    caption: [EPGP convergence on the spherical cavity.],
  ) <tab:sphere>

  #v(2em)

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
      [$delta$], ..bem-runs.map(r => if float(r.at(4)) == 0 { [---] } else { sci(r.at(4)) }),
      [$t$ [s]], ..bem-runs.map(r => [#r.at(5)]),
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
      [$n_"spec"$], ..epgp-runs.map(r => [#r.at(0)]),
      [DOFs], ..epgp-runs.map(r => [#r.at(1)]),
      [$t$ [s]], ..epgp-runs.map(r => [#calc.round(float(r.at(2)), digits: 1)]),
      [cond $amat(A)$], ..epgp-runs.map(r => sci(r.at(4))),
      [$rho$], ..epgp-runs.map(r => sci(r.at(5))),
      [$delta$], ..epgp-runs.map(r => if float(r.at(6)) == 0 { [---] } else { sci(r.at(6)) }),
      [$epsilon$], ..epgp-runs.map(r => sci(r.at(7))),
    )],
    caption: [EPGP convergence on the ellipsoidal cavity.],
  ) <tab:epgp>
]

== Angular Bandwidth and Convergence <sec:res-bandwidth>

_DISCLAIMER: This section has not been fully verified._

// STUB. Spectral explanation of the staircase + floor; condense.

The EPGP error drops in discrete steps and then floors. The argument is spectral.

On $SS^2$ the Laplace--Beltrami eigenfunctions are the spherical harmonics
$-Delta_(SS^2) Y_l^m = l(l + 1) Y_l^m$, degree-$l$ eigenspace dimension $2 l + 1$,
so degrees up to $L$ span $(L + 1)^2$ modes. Separating the Helmholtz equation
gives the multipole expansion $u = sum c_(l m) j_l (k r) Y_l^m$. The Bessel factor
$j_l (x) approx x^l \/ (2 l + 1)!!$ for $l gt.tilde x$ decays super-exponentially,
so the field is band-limited at $L_"max" approx k R$ with $R$ the outer scale.

Plane-wave picture: via $e^(i k kn dot rv) = 4 pi sum i^l j_l (k r) Y_l^m (rn)
conj(Y_l^m (kn))$ and a harmonic expansion of the Herglotz density $g$, the
multipole coefficient is $c_(l m) = 4 pi i^l j_l (k r) g_(l m)$. Resolving the
field to degree $l$ equals resolving $g$ on $SS^2$ to degree $l$. The EPGP samples
$g$ at $n_"spec"$ directions, so reaching degree $L$ needs $n gt.tilde (L + 1)^2$,
i.e. $L(n) approx sqrt(n)$. Each integer degree crossed by $sqrt(n_"spec")$ unlocks
$2 l + 1$ modes and drops the error; between crossings it is flat (the staircase).
Once $sqrt(n_"spec") gt.tilde L_"max" approx k R$, every weighted multipole is
resolved:
$
  "error small" quad <==> quad sqrt(n_"spec") gt.tilde k R
$

#grid(
  columns: 2,
  figure(
    image("../../res/epgp_ksweep.svg"),
    caption: [Ellipsoidal EPGP reciprocity error across wavenumbers.],
  ),
  figure(
    image("../../res/sphere_ksweep.svg"),
    caption: [Spherical EPGP reference error across wavenumbers.],
  )
)

#figure(
  image("../../res/sphere_multipole.svg", width: 80%),
  caption: [Spherical multipole spectrum of $amat(T)_star$.],
)

