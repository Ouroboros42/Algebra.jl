import Base: map, similar

"""
Base for all expressions containing sub-expressions.
Should implement `args` to return a collection of the sub-expressions, which supports `map`.

Should implement `similar` to create a copy with new arguments (identical if given the result of `args`).
Alternatively override `map` directly to create a copy with transformed arguments.
"""
abstract type CompoundExpression{T} <: Expression{T} end

isequal(first::C, second::C) where {C <: CompoundExpression} = isequal(args(first), args(second))
isless(first::C, second::C) where {C <: CompoundExpression} = isless(args(first), args(second))

map(f, compound::CompoundExpression) = similar(compound, map(f, args(compound)))
