function liftconditionals(compound::Compound)
    mapsome(firstornothing(isinst(IfElse) ∘ last, iargs(compound))) do (i, conditional)
        mapbranches(conditional) do branch
            replaceat(compound, i, branch)
        end 
    end
end
liftconditionals(::IfElse) = nothing

tryevaluate(simplifier, ::Type{<:Equality}, a, b) = a == b
tryevaluate(simplifier, ::Type{<:Not}, a::Bool) = !a

trycombine(simplifier, ::Type{<:Not}, not::Not) = arg(not)

areconverse(simplifier, a::Statement, b::Statement) = isequal(simplify(simplifier, !a), b)

function trycombine(simplifier, ::Type{<:IfElse}, condition::Statement, truebranch::Statement, falsebranch::Statement)
    (condition & truebranch) | (!condition & falsebranch)
end

function trycombine(simplifier, ::Type{<:IfElse}, condition::Statement, truebranch::Expression, falsebranch::Expression)
    if condition isa Literal
        return ifelse(condition.value, truebranch, falsebranch)
    end

    if isequal(simplify(updatecontext(simplifier, condition), truebranch == falsebranch), TRUE)
        return falsebranch
    end

    if isequal(simplify(updatecontext(simplifier, !condition), truebranch == falsebranch), TRUE)
        return truebranch
    end
end

trycombine(simplifier, relation::Type{<:Equality}, a::Statement, b::Statement) = (a & b) | (!a & !b)
trycombine(simplifier, relation::Type{<:Equality}, a::Literal{Bool}, b::Literal{Bool}) = @invoke trycombine(simplifier, relation::Type{<:Compound}, a, b)