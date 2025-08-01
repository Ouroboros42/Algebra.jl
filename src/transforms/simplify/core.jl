function tryapply(simplifier::Simplifier, compound::Compound)
    @tryreturn @invoke tryapply(simplifier::Transform, compound)

    if !(compound isa IfElse)
        mapsome(firstornothing(isinst(IfElse) ∘ last, iargs(compound))) do (i, conditional)
            mapbranches(conditional) do branch
                replaceat(compound, i, branch)
            end 
        end
    end
end

function tryapply(simplifier::Simplifier, operation::Operation)
    @tryreturn @invoke tryapply(simplifier, operation::Compound)

    trycombine(simplifier, logicaltype(operation), args(operation)...)
end

"""
Override for types which can be combined together under the given operation.
Returns `nothing` if no transform for the combination is possible.
`outer` should generally only be used for its type.
"""
trycombine(::Simplifier, outer::Type{<:Compound}, args::Expression...) = nothing
trycombine(simplifier, outer::Compound, args...) = trycombine(simplifier, logicaltype(outer), args...)

trycombine(simplifier::Simplifier, outer::Type{<:Compound}, args::Literal...) = mapsome(Literal, tryevaluate(simplifier, outer, map(value, args)...))

tryevaluate(::Simplifier, outer::Type{<:Compound}, args...) = nothing

"""
Override if `initial` has equivalent forms more suitable to combine with `target`.
Returns a sequence of all possible forms.
"""
matchingforms(::Simplifier, ::Type{<:Compound}, target::Expression, initial::Expression) = ()

matchtrycombine(simplifier::Simplifier, outer::Compound, expr1::Expression, expr2::Expression) = matchtrycombine(simplifier, logicaltype(outer), expr1, expr2)
function matchtrycombine(simplifier::Simplifier, outer::Type{<:Compound}, expr1::Expression, expr2::Expression)
    @tryreturn trycombine(simplifier, outer, expr1, expr2)

    for form2 in matchingforms(simplifier, outer, expr1, expr2)
        @tryreturn trycombine(simplifier, outer, expr1, form2)
    end

    for form1 in matchingforms(simplifier, outer, expr2, expr1)
        @tryreturn trycombine(simplifier, outer, form1, expr2)
    end
end