import Base: map, similar, iterate

"""
Base for all expressions containing sub-expressions.
Should implement `args` to return a collection of the sub-expressions, which supports `map`.

Should implement `similar` to create a copy with new arguments (identical if given the result of `args`).
Alternatively override `map` directly to create a copy with transformed arguments.
"""
abstract type CompoundExpression{T} <: Expression{T} end

isequal(first::CompoundExpression, second::CompoundExpression) = isequal(args(first), args(second))
isless(first::CompoundExpression, second::CompoundExpression) = isless(args(first), args(second))

map(f, compound::CompoundExpression) = similar(compound, map(f, args(compound)))

iterate(compound::CompoundExpression) = iterate(args(compound))
iterate(compound::CompoundExpression, state) = iterate(args(compound), state)