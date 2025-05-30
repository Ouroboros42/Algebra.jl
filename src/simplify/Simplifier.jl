abstract type Simplifier end

simplifywith(simplifiers...) = expression -> simplify(expression, simplifiers...)

simplify(expression::Expression, simplifiers::Simplifier...) = simplify(expression, simplifiers)

"""
    simplify(expression::Expression, simplifiers::NTuple{N, Simplifier}) where N

Apply specified simplification schemes to the Expression until it can be updated no more.
Should not need overriding, override `trysimplify`` instead.
"""
function simplify(expression::Expression, simplifiers::NTuple{N, Simplifier}) where N
    for simplifier in simplifiers
        maybe_simplified = trysimplify(expression, simplifier)

        if !isnothing(maybe_simplified)
            @debug "$simplifier simplified $(repr(expression)) to $(repr(maybe_simplified))"

            return simplify(maybe_simplified, simplifiers)
        end
    end

    expression
end

trysimplify(::Expression, ::Simplifier) = nothing

