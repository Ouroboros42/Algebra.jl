import Base: map, similar, iterate

"""
Base for all expressions containing sub-expressions.
Should implement `args` to return a collection of the sub-expressions, which supports `map`.

Should implement `similar` to create a copy with new arguments (identical if given the result of `args`).
Alternatively override `map` directly to create a copy with transformed arguments.
"""
abstract type Compound{T} <: Expression{T} end

"""
Subtypes should implement `optype` to provide a standard copy constructor, as well as an identifier for common methods.
"""
optype(compound::Compound) = optype(typeof(compound))
similar(compound::Compound, args...) = optype(compound)(args...)  
map(f, compound::Compound) = similar(compound, map(f, args(compound)))

isequal(first::Compound, second::Compound) = optype(first) === optype(second) && isequal(args(first), args(second))
function isless(first::Compound, second::Compound)
    typeid1 = objectid(optype(first))
    typeid2 = objectid(optype(second))

    isless(typeid1, typeid2) || ((typeid1 == typeid2) && isless(args(first), args(second)))
end

hash(compound::Compound, h::UInt) = hash(optype(compound), hash(args(operation), h))

iterate(compound::Compound) = iterate(args(compound))
iterate(compound::Compound, state) = iterate(args(compound), state)

dependencies(compound::Compound) = mapreduce(dependencies, union, args(compound), init=Dependencies())