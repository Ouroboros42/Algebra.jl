export simplify, NoSimplify, Trivial

abstract type Simplifier{T} end

struct NoSimplify <: Simplifier{Any} end

struct Trivial <: Simplifier{Any} end

trysimplify(::Expression{T}, ::Simplifier{S}) where {S, T <: S} = nothing
function simplify(expression::Expression, simplifier::Simplifier = Trivial())
    maybe_simplified = trysimplify(expression, simplifier)

    if isnothing(maybe_simplified)
        return expression
    end

    simplify(maybe_simplified, simplifier)
end