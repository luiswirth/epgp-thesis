#import "../setup-math.typ": *
#import "@preview/cetz:0.4.2"

= Cavity Scattering

== Time-Harmonic Maxwell's Equations

- start from the full Maxwell's equations in a linear, homogeneous, isotropic
  medium ($epsilon, mu$ constant), with charge density $rho$ and current $Jv$
$
  curl Ev = -partial_t Bv, quad &&div Dv = rho \
  curl Hv = Jv + partial_t Dv, quad &&div Bv = 0
$
  - constitutive relations $Dv = epsilon Ev$ and $Bv = mu Hv$

- time-harmonic ansatz $Ev(xv, t) = Re(Ev(xv) e^(-i omega t))$, likewise $Hv$,
  so $partial_t |-> -i omega$
$
  curl Ev = i omega mu Hv, quad
  curl Hv = -i omega epsilon Ev + Jv
$
- this corresponds to the spacetime plane wave $e^(i (kv dot xv - omega t))$, whose spatial
  part carries the outgoing-wave sign $e^(+i k r)$
- we fix this $e^(+i k r)$ convention throughout and refer to it by its spatial sign

- source-free interior: no free charges or currents, $rho = 0$, $Jv = 0$
- eliminate $Hv$: Faraday's law recovers it from $Ev$, $Hv = 1/(i omega mu) curl Ev$
- substitute into the second law, gives the curl--curl equation for $Ev$,
  with the curl--curl operator $cal(L) := curl curl - k^2$
$
  curl curl Ev - k^2 Ev = 0, quad k := omega sqrt(epsilon mu) = omega \/ c
$
- $k$ is the wavenumber
- $cal(L)$ is the governing operator in $D$

== Scattering Problem

- interior electromagnetic scattering problem, setup taken from @cavity
- distinct from exterior scattering: bounded domain, no radiation condition at infinity

- the physical pipeline, transmitter to receiver:
  + transmitter: a dipole source placed inside the cavity
  + incident field $Ev^i$: the free-space radiation of that dipole, known in closed form
  + the incident field hits the conducting wall and is scattered (reflected)
  + scattered field $Ev^s$: the cavity response that restores the wall condition, the unknown
  + receiver: measurement of the scattered field back inside the cavity

- total field is the superposition of incident and scattered part
$
  Ev = Ev^i + Ev^s
$
- both fields satisfy the source-free curl--curl equation in the interior (away from the source)

- object of study: the reaction operator mapping dipole excitation to measured response
- a near-field transmit-to-receive operator

#align(center)[
  #block(
    stroke: 0.5pt + luma(150),
    inset: 8pt,
    radius: 5pt,
    fill: luma(250),
    [
      #let stage(title, qty, prep, dom) = box(
        width: 6em, height: 4.8em,
        stroke: 1pt, inset: 5pt, radius: 3pt, fill: white,
      )[
        #set text(size: 9pt, hyphenate: false)
        #set par(justify: false, leading: 0.5em)
        #set align(center + horizon)
        *#title* \
        $#qty$ #text(size: 8pt)[#prep $#dom$]
      ]
      #let step(op, verb) = box(width: 3.8em)[
        #set align(center)
        #set text(size: 9pt)
        $#op$ \
        $arrow.r.long$ \
        #text(size: 8pt, fill: luma(110))[#verb]
      ]
      #grid(
        columns: 9,
        align: horizon,
        column-gutter: 4pt,

        stage("Transmitter", $delta_t$, "on", $Lambda$),
        step($amat(G)$, "radiate"),
        stage("Incident Field", $Ev^i$, "in", $D$),
        step($pi_t$, "trace"),
        stage("Boundary Data", $avec(h)$, "on", $partial D$),
        step($cal(S)$, "solve"),
        stage("Scattered Field", $Ev^s$, "in", $D$),
        step($pi_t^(Lambda)$, "measure"),
        stage("Receiver", $delta_r$, "on", $Lambda$),
      )
    ]
  )
]

=== Incident Field and Dipole Sources

- write the source-to-field separation as $rv := xv - zv$, with distance $r := norm(rv)$
  and unit vector $rn := rv \/ r$
- free-space response to a point source: the fundamental solution of the scalar Helmholtz operator
- it depends only on the distance $r$
$
  Phi(xv, zv) = 1/(4 pi) exp(i k r)/r
$
- satisfying
$
  (-Delta - k^2) Phi(dot, zv) = delta_zv
$

- a dipole is a position--polarization pair $delta = (zv, pv)$, position $zv$, real polarization $pv in RR^3$
- field radiated by a dipole $delta = (zv, pv)$: apply the curl--curl operator
$
  Ev^i (xv; delta) = i/k curl_xv curl_xv (Phi(xv, zv) pv)
$

- factor out the constant polarization $pv$ by linearity
- gives the free-space electric dyadic Green's function $amat(G)$
$
  amat(G)(xv, zv) pv := i/k curl_xv curl_xv (Phi(xv, zv) pv)
$
  - it is the free-space fundamental solution of the curl--curl operator, carrying no
    boundary data
  - name "Green's function" is the standard electromagnetics convention
- it depends only on the separation vector $rv$
- explicit expression
$
  amat(G)(xv, zv) = i k Phi(xv, zv) [(1 + i/(k r) - 1/(k r)^2) amat(I) - (1 + (3 i)/(k r) - 3/(k r)^2) rn rn^transp]
$
- the incident field is then the dyadic applied to the polarization
$
  Ev^i (xv; delta) = amat(G)(xv, zv) pv
$

=== Scattered Field and curl--curl BVP

- need a domain, a cavity, on whose boundary the incident field scatters into a reaction field
- let $D subset.eq RR^3$ be a bounded cavity with perfectly electrically conducting boundary $partial D$

==== PEC Boundary Condition

- perfectly electrically conducting (PEC) boundary condition on the full field $Ev$
$
  pi_t Ev = 0 quad "on" partial D
$
- via the tangential projection trace onto $partial D$, with outward normal $nv_(partial D)$,
  $pi_t := (Ev |-> Ev - (Ev dot nv_(partial D)) nv_(partial D))$
- full field is the superposition $Ev = Ev^i + Ev^s$
- gives the boundary forcing for the unknown scattered field
$
  avec(h) := pi_t Ev^s = -pi_t Ev^i quad "on" partial D
$

==== Interior BVP

- scattered field $Ev^s: D -> CC^3$ restores the conducting-wall condition
- satisfies the interior curl--curl boundary value problem, with the curl--curl operator $cal(L)$
$
  curl curl Ev^s - k^2 Ev^s &= 0 quad "in" D \
  pi_t Ev^s &= avec(h) quad "on" partial D
$
- solving the BVP defines the BVP solution operator $cal(S): avec(h) |-> Ev^s$ mapping
  boundary data to the scattered field
- the BVP solution operator $cal(S)$ is well-defined only when $k^2$ avoids the interior
  Maxwell eigenvalues; at those cavity resonances the homogeneous problem has nontrivial
  solutions and $cal(S)$ becomes singular

=== Measurement

- a receiver dipole $delta_r = (zv_r, pv_r)$ probes the scattered field
- like a transmitter dipole $delta_t = (zv_t, pv_t)$, but it measures instead of emits
- two distinct dipoles, kept apart so that exchanging their roles is a non-trivial operation

- the measured data is the tangential projection trace of the scattered field onto $Lambda$,
  with outward normal $nv_Lambda$
$
  pi_t^Lambda := (Ev |-> Ev - (Ev dot nv_Lambda) nv_Lambda)
$
- the receiver reads this tangential trace out along its polarization $pv_r in T_(zv_r) Lambda$,
  a scalar reaction
$
  r(delta_t, delta_r) = pv_r dot pi_t^Lambda Ev^s (zv_r; delta_t)
$

==== Reciprocity

- swapping transmitter and receiver leaves the scalar reaction unchanged
- Lorentz (Rayleigh--Carson) reciprocity
$
  r(delta_t, delta_r) = r(delta_r, delta_t)
$
- meaningful precisely because the two dipoles differ; coinciding dipoles make the swap trivial

=== Reaction Operator

- so far a single transmit-receive pair; now the full ensemble, where all the
  ingredients above come together
- the dipoles live on a common dipole surface $Lambda subset.eq D$, a closed interior surface
- dipole positions restricted to $Lambda$: $zv in Lambda$
- polarizations restricted to the tangent plane: $pv in T_zv Lambda$ (tangential dipoles)
- rather than fix one polarization per point, we use a full polarization basis of the tangent plane
- real orthonormal tangent basis $e_1(zv), e_2(zv)$ spanning $T_zv Lambda$
- by linearity the response to any polarization $pv in T_zv Lambda$ is a combination of the two basis responses,
  so the basis captures all polarizations
- sampling $N_Lambda$ surface points, each with its two basis polarizations, gives $M = 2 N_Lambda$ dipole configurations
$
  delta_(n a) = (zv_n, e_a (zv_n)), quad n = 1, ..., N_Lambda, quad a in {1, 2}
$
- flatten the pair index $(n, a)$ into a single index $i = 2(n - 1) + a$, so $i = 1, ..., M$
- transmitter and receiver dipoles share this set, so each $delta_i$ is both a possible
  transmitter and a possible receiver
- each transmitter $delta_j$ has its own incident field, BVP, and scattered field;
  each receiver $delta_i$ measures it, giving one entry
$
  amat(T)_(i j) = r(delta_j, delta_i)
$
- the operator collects all pairs, $amat(T) in CC^(M times M)$; one transmitter, all receivers, is one column
- per-pair reciprocity lifts to operator symmetry, $amat(T) = amat(T)^transp$ (complex-symmetric, not Hermitian)
- $amat(T)$ is the object both methods compute; the benchmark compares the two operators they produce

== Geometry

- dipole surface $Lambda$ and wavenumber $k = 2$ are taken from @cavity
- $Lambda$ is the interior unit sphere
$
  Lambda := { xv in RR^3 mid(:) norm(xv) = 1 } subset.eq D
$
- $N_Lambda = 32$ surface points distributed by a Fibonacci sphere (quasi-uniform), $M = 2 N_Lambda = 64$ configurations
- physical scale: wavelength $lambda = 2 pi \/ k approx 3.14$, so the cavity spans
  $approx 2.5$ to $4$ wavelengths, an interior resonant regime

#let cavity-canvas(rx, ry) = cetz.canvas(length: 0.6cm, {
  import cetz.draw: *
  circle((0, 0), radius: (rx, ry), stroke: 1pt, fill: luma(200))
  circle((0, 0), radius: 1, stroke: 0.8pt, fill: luma(150))
  content((0, ry + 0.6))[$partial D$]
  content((rx * 0.52, ry * 0.6))[$D$]
  content((0, 0))[$Lambda$]
})

=== Ellipsoidal Cavity

- interior domain: ellipsoidal cavity, the geometry from @cavity
- semi-axes $avec(a) = (a_1, a_2, a_3) = (4, 4, 6)$
$
  D := { (x_1, x_2, x_3) in RR^3 mid(:) (x_1/a_1)^2 + (x_2/a_2)^2 + (x_3/a_3)^2 < 1 }
$
- no analytic solution available
- $Lambda$ (radius $1$) is well-separated from $partial D$ (shortest semi-axis $a_1 = 4$)

#figure(
  cavity-canvas(6, 4),
  caption: [Ellipsoidal cavity cross-section],
)

=== Spherical Cavity

- not from @cavity; obtained from the ellipsoid by shrinking all semi-axes to the shortest, $a_1 = a_2 = 4$
- gives the interior sphere of radius $R = a_1 = 4$
$
  D := { xv in RR^3 mid(:) norm(xv) < R }, quad R = 4
$
- admits a closed-form analytic solution, used as exact ground truth

#figure(
  cavity-canvas(4, 4),
  caption: [Spherical cavity cross-section],
)

==== Analytic Solution

- spherical symmetry makes the interior BVP separable, so the scattered field has a
  classical closed form; this is what the sphere case buys over the ellipsoid
- the closed-form operator serves as exact ground truth, against which the numerical
  operators are measured
- we use the standard construction @tai without reproducing its derivation: expand the
  scattered field in vector spherical multipoles, impose the PEC wall, solve for the
  coefficients, then evaluate the same measurement as in the general problem
- we record only the formulas as implemented in the code; correctness is established not
  by re-deriving them but empirically: both numerical solvers agree with these formulas
  to $approx 10^(-10)$ independently, and two methodologically unrelated solvers
  agreeing with the same closed-form expressions is strong evidence the formulas are correct

- expand the incident tangential trace on the wall ($r = R$) in tangential vector spherical
  harmonics: $avec(Psi)_(l m)$ (TM-type) and $avec(Phi)_(l m)$ (TE-type)
$
  p_(l m) = inner(pi_t Ev^i, avec(Psi)_(l m))_(r = R), wide
  q_(l m) = inner(pi_t Ev^i, avec(Phi)_(l m))_(r = R)
$
- the PEC wall fixes the scattered field; its tangential trace measured on $Lambda$ ($r = r_0$) is,
  per harmonic,
$
  avec(y)_(l m) = - R/r_0 (psi_l'(k r_0))/(psi_l'(k R)) p_(l m) avec(Psi)_(l m)
  - (j_l (k r_0))/(j_l (k R)) q_(l m) avec(Phi)_(l m)
$
- with the regular spherical Bessel function $j_l$, the Riccati-Bessel function $psi_l (x) = x j_l (x)$,
  the wall radius $R$, and the measurement radius $r_0 = 1$ (the radius of $Lambda$)
- summing over $l, m$ and inserting into the reaction measurement gives the reference operator
  $amat(T)_star$
