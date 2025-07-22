const RepeatableOps = Union{Sum, Prod}

repeated_op(::Type{<:Sum}) = Prod
repeated_op(::Type{<:Prod}) = Pow 

function trycombine(::Trivial, outer::Type{<:RepeatableOps}, expr1::Expression, expr2::Expression)
    mapsome(repeated_op(outer)) do repeated
        if isvalid(repeated, expr1, TWO) && isequal(expr1, expr2)
            return repeated(expr1, TWO)
        end
    end
end

function trycombine(simplifier::Trivial, outer::Type{<:RepeatableOps}, literal1::Literal, literal2::Literal)
    @tryreturn @invoke trycombine(simplifier::Simplifier, outer, literal1, literal2)
    @tryreturn @invoke trycombine(simplifier, outer, literal1::Expression, literal2::Expression)
end

function trycombine(simplifier::Simplifier, outer::Type{<:Sum}, prod1::Prod, prod2::Prod)
    @tryreturn mapsome(Prod, map_single_difference((x, y) -> matchtrycombine(simplifier, outer, x, y), args(prod1), args(prod2)))
    @tryreturn mapsome(Prod, map_one_extra(x -> matchtrycombine(simplifier, outer, x, one(x)), args(prod1), args(prod2)))
end

function trycombine(simplifier::Trivial, outer::Type{<:Sum}, prod1::Prod, prod2::Prod)
    @tryreturn @invoke trycombine(simplifier, outer, prod1::Expression, prod2::Expression)
    @tryreturn @invoke trycombine(simplifier::Simplifier, outer, prod1, prod2)
end