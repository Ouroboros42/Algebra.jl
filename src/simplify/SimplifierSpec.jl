struct SimplifierSpec{C <: Union{Nothing, Statement}, F <: Union{Nothing, AbstractFloat}} <: Simplifier
    context::C
end

floattype(spec::SimplifierSpec{C, F}) where {C, F} = F

const Approximator = SimplifierSpec{C, F} where {C, F <: AbstractFloat}
const Contextual = SimplifierSpec{C} where {C <: Statement}

SimplifierSpec(; context = nothing, floattype = Nothing) = SimplifierSpec{isnothing(context) ? Nothing : Statement, floattype}(context)

simplify(expression::Expression; kwargs...) = apply(SimplifierSpec(; kwargs...), expression)
approximate(expression::Expression; floattype = Float64, kwargs...) = simplify(expression; floattype, kwargs...)