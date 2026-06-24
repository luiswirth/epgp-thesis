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
- we fix this $e^(-i omega t)$ convention throughout; it selects the outgoing-wave
  sign, so radiating fields carry $e^(+i k r)$

- source-free interior: no free charges or currents, $rho = 0$, $Jv = 0$
- eliminate $Hv$: Faraday's law recovers it from $Ev$, $Hv = 1/(i omega mu) curl Ev$
- substitute into the second law, gives the time-harmonic curl--curl equation for $Ev$
$
  curl curl Ev - k^2 Ev = 0, quad k := omega sqrt(epsilon mu) = omega \/ c
$
- $k$ is the wavenumber

- equivalent Laplacian form via the identity $curl curl = grad div - Delta$
$
  -Delta Ev + grad div Ev - k^2 Ev = 0
$
  - the $grad div Ev$ term is a charge source: $div Ev = rho \/ epsilon = 0$ here,
    so it vanishes and the field is divergence-free
- reduces to the vector Helmholtz equation, each Cartesian component scalar Helmholtz
$
  Delta Ev + k^2 Ev = 0
$
- curl--curl is the primitive form; the Helmholtz form holds only on the
  divergence-free fields
- this is the governing equation in $D$

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
- a near-field transmit-to-receive operator; approximating it is a form of operator
  learning (solution-operator surrogate)

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
        step($cal(L)^(-1)$, "solve"),
        stage("Scattered Field", $Ev^s$, "in", $D$),
        step($pi_t$, "measure"),
        stage("Receiver", $delta_r$, "on", $Lambda$),
      )
    ]
  )
]

=== Incident Field and Dipole Sources

- free-space response to a point source: the fundamental solution of the Helmholtz operator
$
  Phi(xv, zv) = 1/(4 pi) exp(i k norm(xv - zv))/norm(xv - zv)
$
- satisfying
$
  (-Delta - k^2) Phi(dot, zv) = delta_zv
$

- a dipole is a position--polarization pair $delta = (zv, pv)$, position $zv$, real polarization $pv in RR^3$
- field radiated by a dipole $delta = (zv, pv)$: apply the curl--curl operator
$
  Ev^i (xv; delta) = Ev^i (xv; zv, pv) = i/k curl_xv curl_xv (Phi(xv, zv) pv)
$

- factor out the constant polarization $pv$ by linearity
- gives the free-space electric dyadic Green's function $amat(G)$
$
  amat(G)(xv, zv) pv := i/k curl_xv curl_xv (Phi(xv, zv) pv)
$
  - it is the free-space fundamental solution of the curl--curl operator, carrying no
    boundary data
  - name "Green's function" is the standard electromagnetics convention
- explicit expression, with separation $r := norm(xv - zv)$ and unit vector $rn := (xv - zv) \/ r$
$
  amat(G)(xv,zv) = i/k Phi [(k^2 + (i k)/r - 2/r^2) amat(I) + (-k^2 - (3 i k)/r + 3/r^2) rn rn^transp]
$

=== Scattered Field and curl--curl BVP

- need a domain, a cavity, on whose boundary the incident field scatters into a reaction field
- let $D subset.eq RR^3$ be a bounded cavity with perfectly electrically conducting boundary $partial D$

==== PEC Boundary Condition

- perfectly electrically conducting (PEC) boundary condition on the full field $Ev$
$
  pi_t Ev = 0 quad "on" partial D
$
- via the tangential projection trace $pi_t := (Ev |-> Ev - (Ev dot nv) nv)$
- full field is the superposition $Ev = Ev^i + Ev^s$
- gives the boundary forcing for the unknown scattered field
$
  avec(h) := pi_t Ev^s = -pi_t Ev^i quad "on" partial D
$

==== Interior BVP

- scattered field $Ev^s: D -> CC^3$ restores the conducting-wall condition
- satisfies the interior curl--curl boundary value problem, with operator $cal(L) := curl curl - k^2$
$
  cal(L) Ev^s = (curl curl - k^2) Ev^s &= 0 quad "in" D \
  pi_t Ev^s &= avec(h) quad "on" partial D
$
- solving the BVP is the inverse $cal(L)^(-1)$ mapping boundary data $avec(h)$ to $Ev^s$
- the inverse exists only when $k^2$ avoids the interior Maxwell eigenvalues; at those
  cavity resonances the homogeneous problem has nontrivial solutions and the operator
  is singular

=== Measurement

- a receiver dipole $delta_r = (zv_r, pv_r)$ probes the scattered field
- like a transmitter dipole $delta_t = (zv_t, pv_t)$, but it measures instead of emits
- two distinct dipoles, kept apart so that exchanging their roles is a non-trivial operation

- measured data: the same tangential projection trace $pi_t$ used for the boundary condition,
  now applied to the scattered field
$
  pi_t Ev^s (xv) = Ev^s (xv) - (Ev^s (xv) dot nv(xv)) nv(xv)
$
- receiver reads it out along its polarization, a scalar reaction
$
  r(delta_t, delta_r) = pv_r dot pi_t Ev^s (zv_r)
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
- transmitter and receiver dipoles share this set, so each $delta_i$ is both a possible
  transmitter and a possible receiver
- each transmitter $delta_j$ has its own incident field, BVP, and scattered field;
  each receiver $delta_i$ measures it, giving one entry
$
  amat(T)_(i j) = r(delta_j, delta_i)
$
- the operator collects all pairs, $amat(T) in CC^(M times M)$; one transmitter, all receivers, is one column
- per-pair reciprocity lifts to operator symmetry, $amat(T) = amat(T)^transp$ (complex-symmetric, not Hermitian)

- full chain from transmitter to receiver, in its computational steps:
  + transmitter dipole $delta_t = (zv_t, pv_t)$
  + dyadic Green's function maps the dipole to its free-space field
  + incident field $Ev^i$
  + incident boundary value: tangential projection trace $pi_t Ev^i$ on the wall
  + PEC condition forces incident and scattered traces to cancel
  + scattered boundary value: negative of the incident boundary value
  + interior boundary value problem for the scattered field
  + scattered field $Ev^s$
  + measurement: tangential projection trace $pi_t Ev^s$ read out by the receiver dipole $delta_r$

== Geometry

- dipole surface $Lambda$ and wavenumber $k = 2$ are taken from @cavity
- $Lambda$ is the interior unit sphere
$
  Lambda := { xv in RR^3 mid(|) norm(xv) = 1 } subset.eq D
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
  D := { (x_1, x_2, x_3) in RR^3 mid(|) (x_1/a_1)^2 + (x_2/a_2)^2 + (x_3/a_3)^2 < 1 }
$
- no analytic solution available

#figure(
  cavity-canvas(6, 4),
  caption: [Ellipsoidal cavity cross-section],
)

=== Spherical Cavity

- not from @cavity; obtained from the ellipsoid by shrinking all semi-axes to the shortest, $a_1 = a_2 = 4$
- gives the interior sphere of radius $R = a_1 = 4$
$
  D := { xv in RR^3 mid(|) norm(xv) < R }, quad R = 4
$
- admits a closed-form analytic solution, used as exact ground truth

#figure(
  cavity-canvas(4, 4),
  caption: [Spherical cavity cross-section],
)

==== Analytic Solution

- scattered field expands in the regular Hansen multipoles $avec(M)_(l m), avec(N)_(l m)$,
  the divergence-free solutions of the curl--curl equation regular at the origin @tai
$
  Ev^s (xv) = sum_(l = 1)^infinity sum_(m = -l)^l [ alpha_(l m) avec(M)_(l m) (xv) + beta_(l m) avec(N)_(l m) (xv) ]
$
- conducting wall at $r = R$ enforces $pi_t (Ev^i + Ev^s) = 0$
- decouples by polarization into the interior PEC reflection coefficients
$
  alpha_(l m) &= k^2 Gamma_l^"TE" (conj(avec(M)_(l m) (zv)) dot pv), wide
  Gamma_l^"TE" = h_l^((1)) (k R) \/ j_l (k R) \
  beta_(l m) &= k^2 Gamma_l^"TM" (conj(avec(N)_(l m) (zv)) dot pv), wide
  Gamma_l^"TM" = xi_l' (k R) \/ psi_l' (k R)
$
- with the Riccati-Bessel functions $psi_l (x) = x j_l (x)$ and $xi_l (x) = x h_l^((1)) (x)$
- reference operator $amat(T)_star$ follows by inserting $Ev^s$ into the same tangential
  measurement on $Lambda$
