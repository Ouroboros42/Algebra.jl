struct Simplifier{C, F}
    context::C
    floattype::F
end

Simplifier(; context = TRUE, floattype = nothing) = Simplifier{isnothing(context) ? Nothing : Statement, typeof(floattype)}(context, floattype)
Simplifier(spec::Simplifier; updates...) = Simplifier(; spec.context, spec.floattype, updates...)

context(simplifier::Simplifier) = simplifier.context
floattype(simplifier::Simplifier) = simplifier.floattype

iscontextual(simplifier) = !isnothing(context(simplifier))

simplify(expression::Expression; kwargs...) = simplify(Simplifier(; kwargs...), expression)
approximate(expression::Expression; floattype = Float64, kwargs...) = simplify(expression; floattype, kwargs...)

nocontext(spec::Simplifier) = Simplifier(spec; context = nothing)

function updatecontext(spec::Simplifier, context::Statement)
    Simplifier(spec; context = isnothing(spec.context) ? context : simplify(nocontext(spec), spec.context & context))
end

updatecontext(spec::Simplifier, context::Nothing) = spec