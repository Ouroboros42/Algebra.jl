struct Simplifier{C, F}
    context::C
    floattype::F
end

Simplifier(; context = TRUE, floattype = nothing) = Simplifier{isnothing(context) ? Nothing : Statement, typeof(floattype)}(context, floattype)
Simplifier(simplifier::Simplifier; updates...) = Simplifier(; simplifier.context, simplifier.floattype, updates...)

context(simplifier::Simplifier) = simplifier.context
floattype(simplifier::Simplifier) = simplifier.floattype

iscontextual(simplifier) = !isnothing(context(simplifier))

simplify(expression::Expression; kwargs...) = simplify(Simplifier(; kwargs...), expression)
approximate(expression::Expression; floattype = Float64, kwargs...) = simplify(expression; floattype, kwargs...)

nocontext(simplifier::Simplifier) = Simplifier(simplifier; context = nothing)

function updatecontext(simplifier::Simplifier, context::Statement)
    newcontext = isnothing(simplifier.context) ? context : simplify(nocontext(simplifier), simplifier.context & context)
    Simplifier(simplifier; context = newcontext)
end
updatecontext(simplifier::Simplifier, context::Nothing) = simplifier
