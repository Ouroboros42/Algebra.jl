"""
Override for types which can be combined together under the given operation.
Returns `nothing` if no transform for the combination is possible.
`outer` should generally only be used for its type.
"""
trycombine(::Simplifier, outer::Type{<:Compound}, args::Expression...) = nothing
