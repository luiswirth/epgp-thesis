#import "../setup.typ": *

= Angular Bandwidth and Convergence <sec:bandwidth>

_DISCLAIMER: This section is exploratory and has not been fully verified._

The EPGP error as a function of $n_"spec"$ shows a characteristic shape: a plateau,
a steep spectral drop, and a floor. On the sphere the drop is clean and
root-exponential, $epsilon_star prop e^(-c sqrt(n_"spec"))$; on the ellipsoid it is
less regular. This appendix collects an exploratory spectral explanation. The
argument is heuristic and explains the order of magnitude only.

#figure(
  grid(
    columns: (1fr, 1fr),
    column-gutter: 6pt,
    image("../../res/sphere_epgp_rate.svg"),
    image("../../res/ellipse_epgp_rate.svg"),
  ),
  caption: [Spectral convergence rate versus $sqrt(n_"spec")$; left sphere, right
    ellipsoid.],
) <fig:rate>

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
i.e. $L(n) approx sqrt(n)$. Once $sqrt(n_"spec") gt.tilde L_"max" approx k R$, every
weighted multipole is resolved:
$
  "error small" quad <==> quad n_"spec" gt.tilde (k R)^2
$

Varying $k$ shifts the drop to the right, roughly as $(k R)^2$, though the match is
only order-of-magnitude. The ellipsoid carries two length scales (its semi-axes),
hence two band edges rather than one, which is the suspected cause of its less
regular convergence.

#grid(
  columns: 2,
  figure(
    image("../../res/ellipse_epgp_ksweep.svg"),
    caption: [Ellipsoidal EPGP reciprocity error across wavenumbers.],
  ),
  figure(
    image("../../res/sphere_epgp_ksweep.svg"),
    caption: [Spherical EPGP reference error across wavenumbers.],
  )
)

#figure(
  image("../../res/sphere_analytic_multipole.svg", width: 80%),
  caption: [Spherical multipole spectrum of $amat(T)_star$.],
)
