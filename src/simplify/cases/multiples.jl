repeated_op(::Type{<:Associative}) = nothing
repeated_op(::Type{<:Sum}) = Prod
repeated_op(::Type{<:Prod}) = Pow 

tryexpand(::Expression) = nothing
expand(expr::Expression) = @ordefault(tryexpand(expr), [expr])

expandprod(factors) = vec(map(Prod, Iterators.product(map(toargs(Sum), factors)...)))
tryexpand(product::Prod) = if any(isinst(Sum), args(product))
    expandprod(args(product))
end
tryexpand((base, exponent)::Pow) = if base isa Sum && exponent isa Literal{<:Integer} && ispositive(exponent)
    expandprod(ntuple(_ -> args(base), value(exponent)))
end

function trycombine(simplifier, outer::Type{<:Associative}, expr1::Expression, expr2::Expression)
    @tryreturn mapsome(repeated_op(outer)) do repeated
        if isvalid(repeated, expr1, TWO) && isequal(expr1, expr2)
            repeated(expr1, TWO)
        end
    end

    if outer <: Sum
        expanded = [expand(expr1); expand(expr2)]
        if length(expanded) > 2
            return Sum(expanded)
        end
    end
end

function trycombine(simplifier, outer::Type{<:Associative}, literal1::Literal, literal2::Literal)
    @tryreturn @invoke trycombine(simplifier, outer::Type{<:Compound}, literal1, literal2)
    @tryreturn @invoke trycombine(simplifier, outer, literal1::Expression, literal2::Expression)
end

function trycombine(simplifier, outer::Type{<:Sum}, prod1::Prod, prod2::Prod)
    @tryreturn mapsome(Prod, map_single_difference((x, y) -> matchtrycombine(simplifier, outer, x, y), args(prod1), args(prod2)))
    @tryreturn mapsome(Prod, map_one_extra(x -> matchtrycombine(simplifier, outer, x, one(x)), args(prod1), args(prod2)))
    @tryreturn @invoke trycombine(simplifier, outer, prod1::Expression, prod2::Expression)
end