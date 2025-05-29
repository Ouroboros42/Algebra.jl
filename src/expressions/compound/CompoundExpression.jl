import Base: map

"""
Base for all expressions containing sub-expressions.
Should implement `args` to return a collection of the sub-expressions.
Should implement `map` to create copy with `args` transformed.
"""
abstract type CompoundExpression{T} <: Expression{T} end

isequal(first::C, second::C) where {C <: CompoundExpression} = isequal(args(first), args(second))
isless(first::C, second::C) where {C <: CompoundExpression} = isless(args(first), args(second))