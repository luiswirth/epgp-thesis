#let math-template(doc) = {
  show math.equation: set text(font: "New Computer Modern Math")
  
  set math.mat(delim: "[")
  set math.vec(delim: "[")

  set math.equation(numbering: "(1)")

  // Make equation referencing only display the number, e.g. (3).
  show ref: it => {
    let el = it.element
    if el != none and el.func() == math.equation {
      // Override equation references.
      link(el.location(), numbering(
        el.numbering,
        ..counter(math.equation).at(el.location())
      ))
    } else {
      // Other references as usual.
      it
    }
  }

  doc
}

#let avec(a) = math.bold(a)
#let vvec(a) = math.accent(math.bold(a), math.arrow)
#let nvec(a) = math.accent(avec(a), math.hat)

#let amat(a) = math.upright(math.bold(a))

#let xv = $avec(x)$
#let yv = $avec(y)$
#let zv = $avec(z)$

#let rv = $avec(r)$
#let rn = $nvec(r)$
#let en = $nvec(e)$

#let kv = $avec(k)$
#let kn = $nvec(k)$
#let av = $avec(a)$

#let dv = $avec(d)$
#let dn = $nvec(d)$

#let xiv = $avec(xi)$

#let nv = $avec(n)$

#let pv = $avec(p)$
#let Ev = $avec(E)$
#let Dv = $avec(D)$
#let Bv = $avec(B)$
#let Hv = $avec(H)$
#let Jv = $avec(J)$


#let ii = $dotless.i$


#let angled(a) = math.lr($chevron.l #a chevron.r$)

#let inner(a, b) = angled($#a, #b$)
#let innerlines(a, b) = angled(math.vec(delim: none, a, b))

#let conj(u) = math.overline(u)
#let transp = math.tack.b
#let herm = math.upright(math.sans("H"))

#let clos(a) = math.overline(a)
#let openint(a,b) = $lr(\] #a, #b \[)$

#let argmin = math.op("arg min", limits: true)
#let argmax = math.op("arg max", limits: true)

#let mesh = $cal(M)$


#let wedge = math.and
#let wedgespace = math.scripts(math.inline(wedge.big))
#let hodge = math.class("unary", math.star)
#let sharp = sym.sharp
#let flat = sym.flat

#let dif = math.class("unary", math.upright($d$))

#let grad = $avec("grad")$
#let curl = $avec("curl")$
#let div = $"div"$


#let H0 = $limits(H)^circle.stroked.small$



#let restr(a) = $lr(#a|)$
#let trace = $"Tr"$

#let lin = $"Lin"$
#let alt = $"Alt"$

#let vol = "vol"

#let dom = "dom"

// Approximate-magnitude prefix: tight tilde (unary class, no operator spacing).
#let ap = math.class("unary", sym.tilde.op)

// Render a CSV scientific-notation string "a.bce-0d" as $a.bc times 10^(-d)$.
#let sci(s) = {
  let parts = s.split("e")
  let mant = calc.round(float(parts.at(0)), digits: 2)
  let exp = int(parts.at(1).trim("+"))
  $#mant times 10^#exp$
}
