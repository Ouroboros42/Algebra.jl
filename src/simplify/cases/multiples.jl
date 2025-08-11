repeated_op(::Type{<:Associative}) = nothing
repeated_op(::Type{<:Sum}) = Prod
repeated_op(::Type{<:Prod}) = Pow 

function trycombine(simplifier, outer::Type{<:Associative}, expr1::Expression, expr2::Expression)
    @tryreturn @invoke trycombine(simplifier, outer::Type{<:Compound}, expr1, expr2)

    @tryreturn mapsome(repeated_op(outer)) do repeated
        if isvalid(repeated, expr1, TWO) && isequal(expr1, expr2)
            repeated(expr1, TWO)
        end
    end
end

function trycombine(simplifier, outer::Type{<:Sum}, expr1::Expression, expr2::Expression)
    @tryreturn @invoke trycombine(simplifier, outer::Type{<:Associative}, expr1, expr2)
    
    expanded = map(tryexpand, (expr1, expr2))

    if !all(isnothing, expanded)
        return @ordefault(expanded[1], expr1) + @ordefault(expanded[2], expr2)
    end
end

function trycombine(simplifier, outer::Type{<:Sum}, prod1::Prod, prod2::Prod)
    @tryreturn mapsome(Prod{valtype(outer)}, map_single_difference((x, y) -> matchtrycombine(simplifier, outer, x, y), args(prod1), args(prod2)))
    @tryreturn mapsome(Prod{valtype(outer)}, map_one_extra(x -> matchtrycombine(simplifier, outer, x, one(x)), args(prod1), args(prod2)))
    @tryreturn @invoke trycombine(simplifier, outer, prod1::Expression, prod2::Expression)
end