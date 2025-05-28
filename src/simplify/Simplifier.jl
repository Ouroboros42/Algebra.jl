export simplify, NoSimplify, Trivial

abstract type Simplifier end

trysimplify(::Expression, ::Simplifier) = nothing

function simplify(expression::Expression, simplifiers::NTuple{N, Simplifier}) where N
    for simplifier in simplifiers
        @debug "Applying $simplifier to $expression"
        maybe_simplified = trysimplify(expression, simplifier)

        if !isnothing(maybe_simplified)
            return simplify(maybe_simplified, simplifiers)
        end
    end

    expression
end

simplify(expression::Expression, simplifiers::Simplifier...) = simplify(expression, simplifiers)

"""Override for types which can be combined together under the given operation - only targets adjacent items."""
trycombine(simplifier::Simplifier, Op, ::Expression, ::Expression) = nothing