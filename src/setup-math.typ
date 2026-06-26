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

#let av = $avec(a)$
#let bv = $avec(b)$
#let cv = $avec(c)$
#let dv = $avec(d)$
#let ev = $avec(e)$
#let fv = $avec(f)$
#let gv = $avec(g)$
#let hv = $avec(h)$
#let iv = $avec(i)$
#let jv = $avec(j)$
#let kv = $avec(k)$
#let lv = $avec(l)$
#let mv = $avec(m)$
#let nv = $avec(n)$
#let ov = $avec(o)$
#let pv = $avec(p)$
#let qv = $avec(q)$
#let rv = $avec(r)$
#let sv = $avec(s)$
#let tv = $avec(t)$
#let uv = $avec(u)$
#let vv = $avec(v)$
#let wv = $avec(w)$
#let xv = $avec(x)$
#let yv = $avec(y)$
#let zv = $avec(z)$

#let Av = $avec(A)$
#let Bv = $avec(B)$
#let Cv = $avec(C)$
#let Dv = $avec(D)$
#let Ev = $avec(E)$
#let Fv = $avec(F)$
#let Gv = $avec(G)$
#let Hv = $avec(H)$
#let Iv = $avec(I)$
#let Jv = $avec(J)$
#let Kv = $avec(K)$
#let Lv = $avec(L)$
#let Mv = $avec(M)$
#let Nv = $avec(N)$
#let Ov = $avec(O)$
#let Pv = $avec(P)$
#let Qv = $avec(Q)$
#let Rv = $avec(R)$
#let Sv = $avec(S)$
#let Tv = $avec(T)$
#let Uv = $avec(U)$
#let Vv = $avec(V)$
#let Wv = $avec(W)$
#let Xv = $avec(X)$
#let Yv = $avec(Y)$
#let Zv = $avec(Z)$

#let an = $nvec(a)$
#let bn = $nvec(b)$
#let cn = $nvec(c)$
#let dn = $nvec(d)$
#let en = $nvec(e)$
#let fn = $nvec(f)$
#let gn = $nvec(g)$
#let hn = $nvec(h)$
//#let in = $nvec(i)$
#let jn = $nvec(j)$
#let kn = $nvec(k)$
#let ln = $nvec(l)$
#let mn = $nvec(m)$
#let nn = $nvec(n)$
#let on = $nvec(o)$
#let pn = $nvec(p)$
#let qn = $nvec(q)$
#let rn = $nvec(r)$
#let sn = $nvec(s)$
#let tn = $nvec(t)$
#let un = $nvec(u)$
#let vn = $nvec(v)$
#let wn = $nvec(w)$
#let xn = $nvec(x)$
#let yn = $nvec(y)$
#let zn = $nvec(z)$


#let ii = $dotless.i$

#let span = math.op("span", limits: true)

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
