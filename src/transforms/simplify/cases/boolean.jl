tryevaluate(::Simplifier, ::Type{<:Equality}, a, b) = a == b
tryevaluate(::Simplifier, ::Type{<:Not}, a::Bool) = !a

trycombine(::Simplifier, ::Type{<:Not}, not::Not) = arg(not)

areconverse(simplifier::Simplifier, a::Expression{Bool}, b::Expression{Bool}) = isequal(apply(simplifier, !a), b)

function trycombine(simplifier::Simplifier, ::Type{<:And}, a::Expression{Bool}, b::Expression{Bool})
    if isequal(a, b); return a end

    if areconverse(simplifier, a, b); return FALSE end
end

function trycombine(simplifier::Simplifier, ::Type{<:Or}, a::Expression{Bool}, b::Expression{Bool})
    if isequal(a, b); return a end

    if areconverse(simplifier, a, b); return TRUE end
end

function trycombine(::Simplifier, ::Type{<:IfElse}, condition::Expression{Bool}, truebranch::Expression{Bool}, falsebranch::Expression{Bool})
    (condition & truebranch) | (!condition & falsebranch)
end

function trycombine(::Simplifier, ::Type{<:IfElse}, condition::Expression{Bool}, truebranch::Expression, falsebranch::Expression)
    if isequal(truebranch, falsebranch)
        truebranch
    end
end