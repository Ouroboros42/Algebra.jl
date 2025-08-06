struct SimplifierSpec{C, F} <: Simplifier
    context::C
    floattype::F
end

SimplifierSpec(; context = TRUE, floattype = nothing) = SimplifierSpec{isnothing(context) ? Nothing : Statement, typeof(floattype)}(context, floattype)
SimplifierSpec(spec::SimplifierSpec; updates...) = SimplifierSpec(; spec.context, spec.floattype, updates...)

context(simplifier::SimplifierSpec) = simplifier.context
floattype(simplifier::SimplifierSpec) = simplifier.floattype

iscontextual(simplifier) = !isnothing(context(simplifier))

simplify(expression::Expression; kwargs...) = simplify(SimplifierSpec(; kwargs...), expression)
approximate(expression::Expression; floattype = Float64, kwargs...) = simplify(expression; floattype, kwargs...)

nocontext(spec::SimplifierSpec) = SimplifierSpec(spec; context = nothing)

function updatecontext(spec::SimplifierSpec, context::Statement)
    SimplifierSpec(spec; context = isnothing(spec.context) ? context : simplify(nocontext(spec), spec.context & context))
end

updatecontext(spec::SimplifierSpec, context::Nothing) = spec