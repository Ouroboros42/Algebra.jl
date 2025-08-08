import Base: map, similar, iterate

"""
Base for all expressions containing sub-expressions.
Should implement `args` to return a collection of the sub-expressions, which supports `map`.

Should implement `similar` to create a copy with new arguments (identical if given the result of `args`).
Alternatively override `map` directly to create a copy with transformed arguments.
"""
abstract type Compound{T} <: Expression{T} end

"""
Subtypes should implement `logicaltype` to provide a standard copy constructor, as well as an identifier for common methods.
"""
logicaltype(compound::Compound) = logicaltype(typeof(compound))
similar(compound::Compound, args...) = logicaltype(compound)(args...)
similar(compound::Compound) = (args...) -> similar(compound, args...)
map(f, compound::Compound) = similar(compound, map(f, args(compound)))

isequal(first::Compound, second::Compound) = logicaltype(first) === logicaltype(second) && isequal(args(first), args(second))
function isless(first::Compound, second::Compound)
    typeid1 = objectid(logicaltype(first))
    typeid2 = objectid(logicaltype(second))

    isless(typeid1, typeid2) || ((typeid1 == typeid2) && isless(args(first), args(second)))
end

hash(compound::Compound, h::UInt) = hash(logicaltype(compound), hash(args(compound), h))

iterate(compound::Compound) = iterate(args(compound))
iterate(compound::Compound, state) = iterate(args(compound), state)

iargs(compound::Compound) = enumerate(args(compound))

trysort(compound::Compound, order::Ordering = Forward) = if !issorted(compound.arguments; order)
    similar(compound, sort(compound.arguments; order))
end

replacesome(compound::Compound, replacements...) = similar(compound, replacesome(args(compound), replacements...))
replaceat(compound::Compound, replacement...) = similar(compound, replaceat(args(compound), replacement...)) 
mapfirst(f, compound::Compound, additional...) = mapsome(similar(compound), mapfirst(f, args(compound), additional...))

dependencies(compound::Compound) = mapreduce(dependencies, union, args(compound), init=Dependencies())

funcstr(funcname, args) = "$funcname($(join(args, ", ")))"
funcstr(compound) = funcstr(op(compound), args(compound))

infixstr(op, args) = isempty(args) ? "(EMPTY $op)" : "($(join(args, " $op ")))"
infixstr(compound) = infixstr(op(compound), args(compound))

infervaltype(operation::Type{<:Compound}, args...) = @ordefault tryinfervaltype(operation, args...) throw(ResultTypeUndefinedError{operation}(args...))
infervaltype(operation::Type{<:Compound}) = (args...) -> infervaltype(operation, args...)

tryinfervaltype(operation::Type{<:Compound}, ArgTypes::Type...) = nothing
tryinfervaltype(operation::Type{<:Compound}, args::SVector) = tryinfervaltype(operation, map(valtype, args)...)
tryinfervaltype(operation::Type{<:Compound}, args::Expression...) = tryinfervaltype(operation, SVector{length(args), Expression}(args))

isvalid(operation::Type{<:Compound}, args...) = !isnothing(infervaltype(operation, args...))