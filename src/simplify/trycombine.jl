trycombine(simplifier, outer::Compound, args...) = trycombine(simplifier, typeof(outer), args...)

"""
Override for types which can be combined together under the given operation.
Returns `nothing` if no transform for the combination is possible.
`outer` should generally only be used for its type.
"""
function trycombine(simplifier, outer::Type{<:Compound}, args::Expression...)
    if all(isinst(Literal), args)
        @tryreturn mapsome(Literal, tryevaluate(simplifier, outer, map(value, args)...))
    end
end

tryevaluate(simplifier, outer::Type{<:Compound}, args...) = nothing

"""
Override if `initial` has equivalent forms more suitable to combine with `target`.
Returns a sequence of all possible forms.
"""
matchingforms(simplifier, ::Type{<:Compound}, target::Expression, initial::Expression) = ()

matchtrycombine(simplifier, outer::Compound, expr1::Expression, expr2::Expression) = matchtrycombine(simplifier, typeof(outer), expr1, expr2)
function matchtrycombine(simplifier, outer::Type{<:Compound}, expr1::Expression, expr2::Expression)
    @tryreturn trycombine(simplifier, outer, expr1, expr2)

    for form2 in matchingforms(simplifier, outer, expr1, expr2)
        @tryreturn trycombine(simplifier, outer, expr1, form2)
    end

    for form1 in matchingforms(simplifier, outer, expr2, expr1)
        @tryreturn trycombine(simplifier, outer, form1, expr2)
    end
end