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
// EPGP convergence runs, sorted by n_spectral. Columns: n_spectral, dofs, secs,
// log_noise, cond, recip, selfconv_vs_finest, err_vs_bem_ref.
#let epgp-runs = csv("../../res/epgp_results.csv").slice(1).sorted(
  key: r => int(r.at(0))
)

= Results and Discussion <sec:results>

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
error
$
  delta := norm(amat(T) - amat(T)_"ref") / norm(amat(T)_"ref")
$ <eq:selfconv>
the relative distance of an operator to the most refined run of its family. For
the BEM family that reference is the p4m4 run, and $delta$ is reported in the same
column of @tab:bem. A small reciprocity error can thus arise from
fortuitous cancellation in the antisymmetric part rather than from genuine
accuracy. We therefore treat $rho$ as an independent sanity check and rely on
$delta$ for the actual error statement. Under that reading the rapidly
diminishing per-degree gains indicate that $amat(T)_"BEM"$ is well converged at
$m 4$.

== Probabilistic Reconstruction <sec:res-epgp>

The EPGP operator is assembled by conditioning the Maxwell plane-wave GP prior
on the tangential-trace boundary data and evaluating the posterior mean of the
scattered field back on $Lambda$. The single convergence knob is the number of
spectral directions $n_"spec"$ on the Fibonacci sphere; larger $n_"spec"$ enriches
the angular bandwidth of the prior.

@tab:epgp collects the EPGP convergence data and @fig:epgp-reciprocity plots the
reciprocity error as a function of $n_"spec"$. It decreases with added directions
and then floors at $rho approx 7 times 10^(-10)$ for large $n_"spec"$. This
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
  epsilon := norm(amat(T)_"EPGP" - amat(T)_"BEM") / norm(amat(T)_"BEM")
$ <eq:epsilon>
measured against the p4m4 BEM reference. As reported in @tab:epgp
and plotted in @fig:comparison, $epsilon$ decreases monotonically with $n_"spec"$,
reaching $epsilon approx 6.7 times 10^(-8)$ at $n_"spec" = 1024$. A boundary-integral
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
      [$delta$], ..bem-runs.map(r => if float(r.at(4)) == 0 { [---] } else { sci(r.at(4)) }),
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
      ..labelbox(7),
      [$n_"spec"$], ..epgp-runs.map(r => [#r.at(0)]),
      [DOFs], ..epgp-runs.map(r => [#r.at(1)]),
      [$t$ [s]], ..epgp-runs.map(r => [#calc.round(float(r.at(2)), digits: 1)]),
      [cond $amat(A)$], ..epgp-runs.map(r => sci(r.at(4))),
      [$rho$], ..epgp-runs.map(r => sci(r.at(5))),
      [$delta$], ..epgp-runs.map(r => if float(r.at(6)) == 0 { [---] } else { sci(r.at(6)) }),
      [$epsilon$], ..epgp-runs.map(r => sci(r.at(7))),
    )],
    caption: [EPGP convergence versus $n_"spec"$: degrees of freedom, assembly
    time, conditioning of the GP system, reciprocity error, self-convergence to
    the finest run, and the relative difference to the BEM reference.],
  ) <tab:epgp>
]

#figure(
  image("../../res/epgp_vs_bem.svg", width: 68%),
  caption: [EPGP--BEM relative operator difference versus $n_"spec"$.],
) <fig:comparison>

Two observations qualify this number. First, the cross-validation error is still
decreasing at $n_"spec" = 1024$ and has not yet floored, so $epsilon approx 6.7 times 10^(-8)$
is best read as an upper bound on the achievable agreement rather than a
converged value. Second, the residual disagreement reflects
genuine discretization differences rather than numerical noise in either solve:
both solvers' reciprocity floors, $ap 2 times 10^(-9)$ for BEM and $ap 7 times
10^(-10)$ for EPGP, lie well below $epsilon$. Because
the EPGP reciprocity floor is roughly two orders of magnitude below the gap, the
residual cannot be attributed to internal EPGP round-off; it is dominated by the
finite angular resolution of the plane-wave prior together with the finite BEM
mesh. Both solvers thus operate well within their numerical floors, and the
benchmark conclusion stands: two unrelated Maxwell solvers agree at the
$10^(-7)$ level.

== Sensitivity and Uncertainty Analysis

#pagebreak(weak: true)

== Angular Bandwidth and Convergence

_DISCLAIMER: This section has not been fully verified._

The EPGP error does not decrease smoothly with the number of spectral directions
$n_"spec"$ but in discrete steps, a staircase that flattens into a floor once
$n_"spec"$ is large enough. This section explains that behaviour. The argument is
spectral; the spherical cavity of @sec:sphere makes it exact, and a wavenumber
sweep confirms it numerically.

#v(1cm)

On the unit sphere $SS^2$ the eigenfunctions of the Laplace--Beltrami operator
are the *spherical harmonics* $Y_l^m$,
$
  -Delta_(SS^2) Y_l^m = l(l + 1) Y_l^m
$
indexed by the degree $l in NN$ and the order $m in {-l, dots, +l}$, its two
quantum numbers. The degree-$l$ eigenspace has dimension $2 l + 1$, so the
harmonics up to degree $L$ span a space of dimension
$
  sum_(l=0)^L (2 l + 1) = (L + 1)^2
$
They are the Fourier modes of the sphere, just as the plane waves
$e^(i kv dot rv)$ are the Fourier modes of Euclidean space $RR^n$.

Separating variables for the Helmholtz equation in spherical coordinates
multiplies each angular mode by a radial factor. A solution regular at the origin
admits the *multipole expansion*
$
  u(rv) = sum_(l=0)^infinity sum_(m=-l)^l c_(l m) j_l (k r) Y_l^m (rn)
$
where $r = norm(rv)$ is the radius, $rn = rv \/ r$ the direction, and the
*spherical Bessel functions* $j_l$ are the radial eigenfunctions regular at the
origin. The decisive property of $j_l$ is its behaviour in the degree $l$ at a
fixed argument $x = k r$: it oscillates for $l < k r$ and, once the degree
exceeds the argument, decays super-exponentially,
$
  j_l (x) approx x^l / (2l + 1)!! quad "for" l gt.tilde x
$
since the double factorial $(2l + 1)!!$ grows super-exponentially in $l$. The
field is therefore effectively band-limited in angular degree, with significant
content only up to
$
  L_"max" approx k R
$
where $R$ is the radius over which the field must be represented, here the outer
scale of the cavity boundary.

The angular content has a second face in the plane-wave picture. Every solution
is a superposition of plane waves over the characteristic variety, the Herglotz
representation with a density $g$ on the direction sphere $SS^2$ established
earlier. The two pictures are linked by the plane-wave expansion
$
  e^(i k kn dot rv) = 4 pi sum_(l=0)^infinity sum_(m=-l)^l i^l j_l (k r) Y_l^m (rn) conj(Y_l^m (kn))
$
Expanding the density in the same harmonics,
$
  g(kn) = sum_(l=0)^infinity sum_(m=-l)^l g_(l m) Y_l^m (kn)
$
and inserting both into the Herglotz integral shows that the multipole
coefficient of the field is the harmonic coefficient of the density weighted by
the Bessel factor,
$
  c_(l m) = 4 pi i^l j_l (k r) g_(l m)
$
so resolving the field up to degree $l$ is the same as resolving the density $g$
on $SS^2$ up to degree $l$.

Here the discrete prior enters. The EPGP uses $n_"spec"$ plane-wave directions,
that is $n_"spec"$ samples of the density on $SS^2$. Resolving degree $L$ needs
its $(L + 1)^2$ modes, so $n$ points on the sphere reach only up to
$
  n gt.tilde (L + 1)^2 quad ==> quad L(n) approx sqrt(n)
$
As $n_"spec"$
grows, $sqrt(n_"spec")$ climbs through the integer degrees. Each time it passes a
degree $l lt.eq L_"max"$, the representable space gains the $2 l + 1$ modes of
that degree and the error drops; between crossings it is flat. This is the
staircase. Once $sqrt(n_"spec")$ exceeds $L_"max" approx k R$, every multipole
that carries weight is resolved and the error stops improving. Equivalently, the
propagating plane waves on a domain of radius $R$ have a finite effective
dimension of order $(k R)^2$, the number of multipoles up to degree $k R$, which
is reached near $n_"spec" approx (k R)^2$. In short,
$
  "error small" quad <==> quad L(n_"spec") gt.tilde L_"max" quad <==> quad sqrt(n_"spec") gt.tilde k R
$

The spherical cavity makes this exact. With the wall a sphere of radius $R$ the
reaction operator is a closed multipole sum whose entries decay geometrically
beyond $l approx k R$, so it is, to any fixed accuracy, a matrix of rank
$approx 2 (k R)^2$. The derivation and the explicit Bessel cut-off are carried out
in @sec:sphere. The ellipsoid admits no such closed form, but the same
outer-scale argument applies with $R$ the largest semi-axis.

The prediction $sqrt(n_"spec") gt.tilde k R$ is dimensional, so the staircase drop
must move with the wavenumber, sitting at $n_"spec" approx (k R)^2$. We test this
by assembling the operator over a range of wavenumbers $k in {1, 1.5, 2, 2.5, 3}$
at otherwise fixed settings, using the reciprocity error $rho$ as the
reference-free convergence indicator so that no BEM run is needed per $k$.
@fig:ksweep shows the outcome. The drop slides right by roughly a factor of five
in $n_"spec"$ as $k$ triples, and for every curve it falls in the predicted band
near $n_"spec" approx (k R)^2$ marked by the dotted lines, with $R$ the largest
semi-axis and no fitted parameter. The transition is a band rather than a sharp
step because the Fibonacci directions form a low-discrepancy sequence and not a
spherical $t$-design, so a degree is unlocked over a short range of crossings
rather than at a single one.

#figure(
  image("../../res/epgp_ksweep.svg", width: 80%),
  caption: [EPGP reciprocity error across wavenumbers. Dotted lines mark the
  predicted drop at $n_"spec" = (k R)^2$.],
) <fig:ksweep>

What sets the floor is a separate matter from what sets the drop. Once the field
is resolved the error does not continue down to the super-exponential Bessel tail
but levels off at a numerical floor. @tab:epgp shows the cause: the tuned
observation noise reaches its lower clip and the condition number of the GP system
climbs past $10^(10)$ as the plane-wave basis turns overcomplete, so additional
directions can no longer lower the error. The floor is thus a conditioning and
regularization effect; the angular band limit governs only the location of the
drop, not the level of the floor.

The cavity resonances do not disturb this picture. The interior conducting problem
has a discrete real spectrum, dense in the swept range: by Weyl's law there are of
order $(k R)^3$ modes below $k$, and the operator is singular at each resonance. A
subspace-angle scan over $k$ places the lowest eigen-wavenumbers near
$k approx 0.59, 0.67, 0.79$ and confirms that the swept points
$k in {1, dots, 3}$ sit between modes rather than on them. Proximity to a
resonance does not track the floor level across $k$, which corroborates that the
floor is numerical rather than resonant.

The argument above uses the scalar Helmholtz equation for clarity. The honest
setting is vector Maxwell, where each direction carries two transverse
polarizations $Ev perp kv$, matching the $2 n_"spec"$ features of the prior, and
the multipoles are the TE and TM Hansen families. The radial factor stays
$j_l (k r)$, so the band limit $L_"max" approx k R$ is unchanged and the effective
dimension only gains a factor two, $approx 2 (k R)^2$. The spherical-cavity
derivation in @sec:sphere carries out this vector case in full.
