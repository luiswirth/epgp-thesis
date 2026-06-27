#import "../setup-math.typ": *

#let bem-runs = csv("../../res/ellipse_bem_results.csv").slice(1).sorted(
  key: r => (int(r.at(0)), int(r.at(1)))
)
#let _epgp-all = csv("../../res/ellipse_epgp_results.csv").slice(1)
#let _epgp-nb-max = calc.max(.._epgp-all.map(r => int(r.at(1))))
#let epgp-runs = _epgp-all.filter(r => int(r.at(1)) == _epgp-nb-max).sorted(
  key: r => int(r.at(0))
)

= Benchmark Results

We present results for two cavity geometries, which differ in what we can validate against. The spherical cavity admits a closed-form operator and is used to check each solver against ground truth; the ellipsoidal cavity admits none and is treated by cross-validation.
Each geometry is treated in turn, covering the EPGP solver, the BEM solver, and, for the ellipsoid, a direct comparison of the two.

Two relative error measures are used throughout. The reciprocity error $rho$ is reference-free: reciprocity forces the true operator to be symmetric, and $rho$ measures the violation of that symmetry. It is a necessary but not sufficient check.
The reference error $epsilon$ is the distance to a trusted reference operator $amat(T)_"ref"$,
which is the analytic operator $amat(T)_"anal"$ on the sphere and the high-fidelity BEM operator $amat(T)_"BEM"$ on the ellipsoid.
$
  rho := norm(amat(T) - amat(T)^transp) / norm(amat(T)) quad quad
  epsilon := norm(amat(T) - amat(T)_"ref") / norm(amat(T)_"ref")
$

We use the Frobenius norm to quantify distance between operators.
The operator norm is bounded by the Frobenius norm, so convergence in $epsilon$ implies convergence in the operator norm.
$
  norm(amat(T))_"op" <= norm(amat(T))_"F"
$

#pagebreak(weak: true)
== Spherical Cavity

The spherical cavity is a PEC sphere of radius $R = 4$.
It admits a closed-form reaction operator of unlimited accuracy, which serves as ground truth for both solvers.

=== EPGP Field

We begin with a qualitative look at the EPGP solution for a single transmitter dipole at $zv = (0, 0, 1)$ on $Lambda$, polarized along $x$. Being a probabilistic solver, the EPGP returns a full posterior over the scattered field, a Gaussian summarized by its mean and its covariance: the mean is the point estimate of the field, and the covariance is its uncertainty. We visualize both on the $x z$-plane ($y = 0$) through the cavity, the dipole location marked in green. The field was computed at the highest grid resolution $N_s = 1024$, $N_b = 8192$.

==== Mean

@fig:sphere-field shows the posterior mean field. The top row is the real part of the $x$-component as a heatmap, the bottom row the field lines via line-integral convolution (LIC). The three columns are the incident, scattered, and total field. The incident field is the dipole near field, sharply localized at the source. Scattering off the wall produces the scattered field, and together they form the total field.

The result matches physical expectations. Both the incident and scattered fields are traveling waves carrying energy, but their energy flows cancel, so the total field is a pure standing wave. The spherical symmetry of the cavity is clearly visible: the scattered wavefronts are concentric and the LIC field lines form smooth rings.

#figure(
  grid(
    columns: 1,
    row-gutter: 6pt,
    image("../../res/epgp_sphere_field_real.png"),
    image("../../res/epgp_sphere_field_lic.png"),
  ),
  caption: [EPGP field on the spherical cavity slice.],
) <fig:sphere-field>

==== Uncertainty

The mean is paired with a posterior uncertainty, the standard deviation of the field about that mean. Only the scattered field is inferred and thus carries uncertainty. The incident field is exact, so the total field's uncertainty is identical to the scattered field's. @fig:sphere-field-std maps this standard deviation over the same slice. It is small, of order $10^(-3)$, and forms concentric rings that grow from the center toward the wall.

That the uncertainty is largest at the wall may look backwards, since the wall is where we condition. The reason is that we condition only on the tangential part of the field. At the wall the tangential part is fixed, while the part pointing straight out of the wall, the normal component, is left free, and that free part stays uncertain. In the interior there is no such free direction: the field equations tie the components together and the plane-wave prior fills in the field from the boundary data, so the uncertainty fades toward the center. The map thus shows how well the boundary data determines the field, not the size of the true reconstruction error.

#figure(
  image("../../res/epgp_sphere_field_std.png", width: 60%),
  caption: [EPGP scattered-field uncertainty on the spherical cavity slice.],
) <fig:sphere-field-std>

=== EPGP Operator

Having inspected the field, we turn to the reaction operator itself. @fig:sphere-operator shows its magnitude alongside the posterior uncertainty. The left panel is a heatmap of the magnitude $|amat(T)|$, a $64 times 64$ matrix over receiver $i$ and transmitter $j$. The $64$ rows and columns are $32$ surface points on $Lambda$, each carrying two tangential polarizations, so consecutive index pairs share a $Lambda$ point. The largest entries lie along the diagonal, where each dipole couples most strongly to itself and its near neighbours. The right panel is a heatmap of the per-receiver posterior standard deviation $sigma_i = sqrt(amat(Sigma)_(i i))$, which depends on the receiver but not the transmitter.

This is because the posterior covariance is fixed only by where we condition and where we evaluate, not by the measured values. We always condition at the same boundary points for every transmitter, and only the boundary values change, so all transmitters share the same covariance. The receiver, by contrast, is the evaluation point, so the uncertainty can in general vary from receiver to receiver. On the sphere, symmetry makes all receivers equivalent, so here $sigma$ is uniform across the panel.

#figure(
  image("../../res/sphere_uq_operator.png"),
  caption: [Reaction operator $|amat(T)|$ and posterior uncertainty $sigma$, spherical cavity.],
) <fig:sphere-operator>

==== Convergence

We now quantify the operator's accuracy as the resolution grows. @fig:sphere-epgp-conv plots the reference error $epsilon$ against the number of spectral features $N_s$, one curve per boundary-point count $N_b$. For small $N_s$ all curves coincide, so spectral resolution alone limits accuracy. Past $N_s approx 200$ each curve flattens to a floor set by its $N_b$, with the finest curve reaching $epsilon approx 1.3 times 10^(-10)$ at $N_s = 1024$ and $N_b = 8192$.

#figure(
  image("../../res/epgp_sphere_convergence.svg", width: 68%),
  caption: [EPGP convergence on the spherical cavity versus analytic reference.],
) <fig:sphere-epgp-conv>

==== Noise Influence

A free parameter of the solver is the assumed boundary noise $sigma_n$, which regularizes the conditioning. @fig:sphere-noise sweeps it. We show the sweep for the sphere, where the true reconstruction error is available against the analytic operator. The ellipsoid behaves the same. More noise means stronger regularization, so both the reconstruction error and the predicted uncertainty grow. On the log-log axes the growth is nearly a straight line, indicating a power-law dependence on $sigma_n$.

Both rise because $sigma_n$ drives them: it inflates the predicted variance directly and, through stronger regularization, also worsens the reconstruction. Their covariation does not mean that uncertainty tracks the reconstruction error. The predicted uncertainty is thus governed largely by the assumed noise, which is what makes its calibration delicate.

#figure(
  image("../../res/sphere_noise.svg", width: 68%),
  caption: [Reconstruction error and predicted uncertainty vs assumed noise, spherical cavity.],
) <fig:sphere-noise>

=== BEM Operator

The BEM is deterministic, so it returns the operator without an uncertainty estimate. We assess its accuracy by convergence against the analytic reference.

==== Convergence

@fig:sphere-bem-conv splits this convergence into two panels, each a family of curves over one fixed parameter. The left panel performs $h$-refinement, varying the mesh level $m$ at each fixed polynomial degree $p$, plotted against degrees of freedom on log--log axes. Algebraic convergence appears as a straight line there, and each curve is one, with a slope that steepens with $p$; a $prop N^(-3\/2)$ reference line is included for comparison. The right panel performs $p$-refinement, varying $p$ at each fixed mesh level, plotted against $p$ on a semilog axis. Geometric convergence appears as a straight line there, and each curve is one. The two refinements thus behave as the theory predicts, and the finest resolutions reach $epsilon approx 3 times 10^(-12)$. The only exception is the $p = 5$, $m = 4$ point, which ticks back up as it reaches the floor of attainable accuracy.

#figure(
  image("../../res/bem_sphere_convergence.svg"),
  caption: [BEM convergence on the spherical cavity versus analytic reference.],
) <fig:sphere-bem-conv>

#pagebreak(weak: true)
=== Wavenumber Sweep

The benchmark fixes $k = 2$. A cavity resonance, where the interior boundary value problem is not uniquely solvable, would make the reconstruction ill-posed, so we check that $k = 2$ avoids one. We sweep $k$ and record the smallest singular value $sigma_min$ of the orthonormalized boundary trace of the plane-wave feature space, which collapses toward zero at a resonance and is bounded away from it otherwise.

@fig:sphere-ksweep shows the sweep on the sphere over $k in [1.5, 2.5]$. Every dip of $sigma_min$ coincides with an analytic resonance of the sphere (dashed), so the diagnostic locates resonances correctly. The benchmark wavenumber $k = 2$ sits at a local maximum, far from any resonance, confirming that it is non-resonant.

#figure(
  image("../../res/sphere_epgp_ksweep.svg", width: 78%),
  caption: [Wavenumber sweep, spherical cavity.],
) <fig:sphere-ksweep>

== Ellipsoidal Cavity

The ellipsoidal cavity has semi-axes $(4, 4, 6)$, keeping the same interior surface $Lambda$ and wavenumber $k = 2$. Unlike the sphere, it admits no analytic operator: the ellipsoid does not separate the vector Helmholtz equation in any standard coordinate system, so no closed-form eigenfunction expansion exists. The high-fidelity BEM solution therefore serves as the reference.

=== EPGP Field

We repeat the qualitative inspection of the previous section, visualizing the EPGP posterior for the same transmitter dipole at $zv = (0, 0, 1)$ on $Lambda$, polarized along $x$, on the same $x z$-plane through the cavity. The elongated geometry breaks the spherical symmetry, and the contrast with the sphere is the point of interest.

==== Mean

@fig:ellipse-field shows the posterior mean field in the same layout as before: the real part of the $x$-component as a heatmap (top) and the field lines via LIC (bottom), for the incident, scattered, and total field. The broken symmetry is clearly visible. The incident field is the same as before, since it is the same dipole, but the scattered field no longer shows the concentric wavefronts of the sphere. Instead it has a more intricate pattern, stretched along the long axis of the cavity, and the same is seen in the LIC field lines. The total field is again the sum of the two.

#figure(
  grid(
    columns: 1,
    row-gutter: 6pt,
    image("../../res/epgp_ellipse_field_real.png"),
    image("../../res/epgp_ellipse_field_lic.png"),
  ),
  caption: [EPGP field on the ellipsoidal cavity slice.],
) <fig:ellipse-field>

==== Uncertainty

@fig:ellipse-field-std maps the posterior uncertainty over the same slice. The same effect is at work, but the broken symmetry makes it richer. The uncertainty is again lowest in the interior and grows toward the wall, where the free normal component carries it, but now it breaks into separate lobes. The lobes sit where the field hits the wall most steeply, so its normal component there is large, while the quiet valleys between them are where the field runs almost along the wall and the tangential conditioning already fixes it. The scale is also an order of magnitude larger than on the sphere, of order $10^(-2)$.

#figure(
  image("../../res/epgp_ellipse_field_std.png", width: 60%),
  caption: [EPGP scattered-field uncertainty on the ellipsoidal cavity slice.],
) <fig:ellipse-field-std>

=== EPGP Operator

As on the sphere, @fig:ellipse-operator shows the operator magnitude beside the posterior uncertainty. The magnitude $|amat(T)|$ keeps the same diagonal structure of strong self- and near-coupling. The uncertainty, however, is no longer uniform: the elongated geometry breaks the equivalence of receivers, so $sigma$ now varies from receiver to receiver, visible as the horizontal banding. It grows for receivers deeper inside the cavity, toward the elongated $z$-axis and away from the wall, because the boundary data constrains near-wall receivers more tightly than deep-interior ones.

#figure(
  image("../../res/ellipse_uq_operator.png"),
  caption: [Reaction operator $|amat(T)|$ and posterior uncertainty $sigma$, ellipsoidal cavity.],
) <fig:ellipse-operator>

==== Convergence

With no analytic operator available, we track accuracy through the reciprocity error $rho$, which needs no reference. @fig:ellipse-epgp-conv plots $rho$ against the number of spectral features $N_s$. It decreases steadily and floors at $rho approx 3 times 10^(-11)$, confirming that the EPGP operator is symmetric to that level. The cross-validation reference error $epsilon$ against the BEM reference is reported in the table below. @tab:ellipse-epgp lists the corresponding runs at the finest $N_b$, together with their runtime, memory, and conditioning.

#figure(
  image("../../res/epgp_ellipse_convergence.svg", width: 68%),
  caption: [EPGP reciprocity error on the ellipsoidal cavity versus $N_s$ (no analytic reference; cross-validation error $epsilon$ in @tab:ellipse-epgp).],
) <fig:ellipse-epgp-conv>

=== BEM Operator

The BEM operator is the reference for this geometry. As for the EPGP, the absence of an analytic operator leaves only the reciprocity error $rho$ as a self-contained measure.

==== Convergence

@fig:ellipse-bem-conv plots the BEM reciprocity error $rho$ over the $p times m$ grid, and @tab:ellipse-bem lists every run with its degrees of freedom, runtime, memory, and conditioning. Here only $rho$ is available, which sees the antisymmetric part of the error and so cannot certify a convergence order, but its decay is consistent with the algebraic $h$-refinement and geometric $p$-refinement established on the sphere. The most refined run, $p = 5$, $m = 4$ ($4800$ DOFs), reaches $rho approx 1.4 times 10^(-10)$ and serves as the reference operator $amat(T)_"BEM"$ for this geometry.

#figure(
  image("../../res/bem_ellipse_convergence.svg"),
  caption: [BEM reciprocity error on the ellipsoidal cavity.],
) <fig:ellipse-bem-conv>

=== Wavenumber Sweep

The same sweep on the ellipsoid is shown in @fig:ellipse-ksweep. No analytic resonances are available for comparison, but $k = 2$ again sits at a local maximum of $sigma_min$, away from the dips, so it is non-resonant for this geometry too.

#figure(
  image("../../res/ellipse_epgp_ksweep.svg", width: 78%),
  caption: [Wavenumber sweep, ellipsoidal cavity.],
) <fig:ellipse-ksweep>

=== Comparison

Having validated each solver on its own, we now compare them directly, first in accuracy and then in cost.

==== Cross-Validation

The two solvers share no numerical machinery, so their agreement is strong evidence for both. We quantify it by the reference error $epsilon$ of the EPGP operator against the BEM reference $amat(T)_"BEM"$. It decreases monotonically with $N_s$, reaching $epsilon approx 9 times 10^(-9)$ at $N_s = 1024$, and is still decreasing there, so $9 times 10^(-9)$ is an upper bound on the relative difference: the two operators are at least this close.

Together with the independent certification of each solver on the analytic sphere, this is the central result of the benchmark. Two methodologically unrelated solvers, each validated on its own and then shown to agree on a geometry with no ground truth, give strong combined evidence that both compute the correct reaction operator.

==== Accuracy--Runtime Trade-off

All runs were carried out on the Euler cluster, each on a single exclusive AMD EPYC 7742 node with 128 cores, and wall time was recorded per run. For the EPGP the recorded time includes the JAX just-in-time compilation and the Python startup, so it is a conservative measure.

@fig:ellipse-pareto plots reciprocity error against wall time for both solvers. The faint points are all grid runs and the solid line is each solver's Pareto front. The two fronts have very different shapes. The EPGP front is nearly vertical, between $approx 6$ and $18$ s: its reciprocity error improves by orders of magnitude at almost fixed wall time, because the cost is dominated by the one-off factorization. The BEM front is a staircase that descends only with large increases in wall time, reaching $rho approx 1.4 times 10^(-10)$ at $approx 1600$ s at the finest grid run ($p = 5$, $m = 4$).

At the same reciprocity error the EPGP is two to three orders of magnitude faster, reaching $rho approx 10^(-9)$ to $10^(-10)$ in about $10$ s. The BEM is cheaper only at loose tolerance. For any demanding accuracy the EPGP is the cheaper solver.

These wall times reflect two particular implementations, a compiled C++ solver and a Python/JAX one, so the absolute factor mixes implementation quality with algorithmic cost. The implementation-independent comparison is asymptotic. Both solvers factor their system once and reuse it across the $M = 64$ dipole right-hand sides. The dense BEM factorization costs $cal(O)(N^3)$ in the $N tilde p^2 4^m$ surface degrees of freedom, while the EPGP system assembly costs $cal(O)(N_s^2 N_b)$ and its factorization $cal(O)(N_s^3)$; since $N_b > N_s$ in practice, assembly dominates.

#figure(
  image("../../res/pareto_ellipse.svg"),
  caption: [Reciprocity error vs wall time for BEM and EPGP on the ellipsoidal cavity.],
) <fig:ellipse-pareto>

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
      [cond $amat(V)$], ..bem-runs.map(r => sci(r.at(5))),
      [$rho$],          ..bem-runs.map(r => sci(r.at(7))),
    )],
    caption: [BEM convergence on the ellipsoidal cavity.],
  ) <tab:ellipse-bem>

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
  ) <tab:ellipse-epgp>
]
