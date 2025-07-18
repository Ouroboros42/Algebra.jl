import Base: map, similar, iterate

"""
Base for all expressions containing sub-expressions.
Should implement `args` to return a collection of the sub-expressions, which supports `map`.

Should implement `similar` to create a copy with new arguments (identical if given the result of `args`).
Alternatively override `map` directly to create a copy with transformed arguments.
"""
abstract type Compound{T} <: Expression{T} end

map(f, compound::Compound) = similar(compound, map(f, args(compound)))

iterate(compound::Compound) = iterate(args(compound))
iterate(compound::Compound, state) = iterate(args(compound), state)

dependencies(compound::Compound) = mapreduce(dependencies, union, args(compound), init=Dependencies())