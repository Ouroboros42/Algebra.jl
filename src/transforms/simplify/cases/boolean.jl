tryevaluate(::Trivial, ::Type{<:Equality}, a, b) = a == b
tryevaluate(::Trivial, ::Type{<:Not}, a::Bool) = !a

trycombine(::Trivial, ::Type{<:Not}, not::Not) = arg(not)

areconverse(simplifier::Simplifier, a::Expression{Bool}, b::Expression{Bool}) = isequal(apply(simplifier, !a), b)

function trycombine(simplifier::Simplifier, ::Type{<:And}, a::Expression{Bool}, b::Expression{Bool})
    if isequal(a, b); return a end

    if areconverse(simplifier, a, b); return FALSE end
end

function trycombine(simplifier::Simplifier, ::Type{<:Or}, a::Expression{Bool}, b::Expression{Bool})
    if isequal(a, b); return a end

    if areconverse(simplifier, a, b); return TRUE end
end

function tryapply(::Trivial, compound::Compound)
    if compound isa IfElse; return end

    mapsome(firstornothing(isinst(IfElse) ∘ last, iargs(compound))) do (i, conditional)
        mapbranches(conditional) do branch
            replacesomeargs(compound, i => branch)
        end 
    end
end

function tryapply(::Trivial, conditional::IfElse{Bool})
    (condition(conditional) & truebranch(conditional)) | (!condition(conditional) & falsebranch(conditional))
end