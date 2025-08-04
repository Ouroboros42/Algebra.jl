struct SimplifierSpec{C <: Union{Nothing, Statement}, F <: Union{Nothing, AbstractFloat}} <: Simplifier
    context::C
end

floattype(spec::SimplifierSpec{C, F}) where {C, F} = F

const Approximator = SimplifierSpec{C, F} where {C, F <: AbstractFloat}
const Contextual = SimplifierSpec{C} where {C <: Statement}

SimplifierSpec(; context = TRUE, floattype = Nothing) = SimplifierSpec{isnothing(context) ? Nothing : Statement, floattype}(context)
SimplifierSpec(spec::SimplifierSpec; updates...) = SimplifierSpec(; spec.context, floattype=floattype(spec), updates...)

simplify(expression::Expression; kwargs...) = apply(SimplifierSpec(; kwargs...), expression)
approximate(expression::Expression; floattype = Float64, kwargs...) = simplify(expression; floattype, kwargs...)

nocontext(spec::SimplifierSpec) = SimplifierSpec(spec; context = nothing)
updatecontext(spec::SimplifierSpec, context::Statement) = SimplifierSpec(spec; context)
updatecontext(spec::Contextual, context::Statement) = SimplifierSpec(spec; context = apply(nocontext(spec), spec.context & context))
updatecontext(spec::SimplifierSpec, context::Nothing) = spec