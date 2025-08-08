Base.@kwdef struct Simplifier{C, F}
    context::C = nothing
    floattype::F = nothing
end

context(simplifier::Simplifier) = simplifier.context
floattype(simplifier::Simplifier) = simplifier.floattype

iscontextual(simplifier) = !isnothing(context(simplifier))

simplify(expression::Expression; kwargs...) = simplify(Simplifier(; kwargs...), expression)
approximate(expression::Expression; floattype = Float64, kwargs...) = simplify(expression; floattype, kwargs...)

nocontext(simplifier::Simplifier) = @set simplifier.context = nothing

function updatecontext(simplifier::Simplifier, context::Statement)
    newcontext = isnothing(simplifier.context) ? context : simplify(nocontext(simplifier), simplifier.context & context)
    
    @set simplifier.context = newcontext
end
updatecontext(simplifier::Simplifier, context::Nothing) = simplifier
