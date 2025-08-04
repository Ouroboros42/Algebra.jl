tryevaluate(::Simplifier, ::Type{<:Equality}, a, b) = a == b
tryevaluate(::Simplifier, ::Type{<:Not}, a::Bool) = !a

trycombine(::Simplifier, ::Type{<:Not}, not::Not) = arg(not)

areconverse(simplifier::Simplifier, a::Statement, b::Statement) = isequal(apply(simplifier, !a), b)

function trycombine(simplifier::Simplifier, ::Type{<:And}, a::Statement, b::Statement)
    if isequal(a, b); return a end

    if areconverse(simplifier, a, b); return FALSE end
end

function trycombine(simplifier::Simplifier, ::Type{<:Or}, a::Statement, b::Statement)
    if isequal(a, b); return a end

    if areconverse(simplifier, a, b); return TRUE end
end

function trycombine(::Simplifier, ::Type{<:IfElse}, condition::Statement, truebranch::Statement, falsebranch::Statement)
    (condition & truebranch) | (!condition & falsebranch)
end

function trycombine(::Simplifier, ::Type{<:IfElse}, condition::Statement, truebranch::Expression, falsebranch::Expression)
    if condition isa Literal
        return ifelse(condition.value, truebranch, falsebranch)
    end

    if isequal(truebranch, falsebranch)
        return truebranch
    end
end