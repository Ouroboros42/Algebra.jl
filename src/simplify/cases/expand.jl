expand(expr::Expression) = @ordefault(tryexpand(expr), expr)

tryexpand(::Expression) = nothing

expandprod(factors) = sum(prod, Iterators.product(map(toargs(Sum), factors)...))
tryexpand(product::Prod) = if any(isinst(Sum), args(product))
    expandprod(args(product))
end
tryexpand((base, exponent)::Pow) = if base isa Sum && exponent isa Literal{<:Integer} && ispositive(exponent)
    expandprod(ntuple(_ -> args(base), value(exponent)))
end
