tryapply(simplifier::Simplifier, operation::Operation) = trycombine(simplifier, logicaltype(operation), args(operation)...)

"""
Override for types which can be combined together under the given operation.
Returns `nothing` if no transform for the combination is possible.
`outer` should generally only be used for its type.
"""
trycombine(::Simplifier, outer::Type{<:Compound}, args::Expression...) = nothing
trycombine(simplifier, outer::Compound, args...) = trycombine(simplifier, logicaltype(outer), args...)

trycombine(simplifier::Simplifier, outer::Type{<:Compound}, args::Literal...) = mapsome(Literal, tryevaluate(simplifier, outer, map(value, args)...))

tryevaluate(::Simplifier, outer::Type{<:Compound}, args...) = nothing