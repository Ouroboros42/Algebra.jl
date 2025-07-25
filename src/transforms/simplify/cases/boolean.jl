tryevaluate(::Trivial, ::Type{<:Equality}, a, b) = a == b
tryevaluate(::Trivial, ::Type{<:Not}, a::Bool) = !a

trycombine(::Trivial, ::Type{<:Not}, not::Not) = arg(not)

function tryapply(::Trivial, compound::Compound)
    if compound isa IfElse; return end

    mapsome(firstornothing(isinst(IfElse) ∘ last, iargs(compound))) do (i, conditional)
        mapbranches(conditional) do branch
            replacesomeargs(compound, i => branch)
        end 
    end
end