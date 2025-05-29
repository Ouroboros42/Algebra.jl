"""
An associative operation, labelled by `Op`, which is usually the equivalent julia function. 
"""
struct AssociativeOperation{Op, T, E <: Expression} <: CompoundExpression{T}
    arguments::Vector{E}
end

AssociativeOperation{Op, T}(arguments::Vector{E}) where {Op, T, E} = AssociativeOperation{Op, T, E}(arguments)

AssociativeOperation{Op}(arguments::Vector{<:Expression}) where Op = AssociativeOperation{Op, resulttype(Op, arguments)}(arguments)
AssociativeOperation{Op}(arguments::Expression...) where Op = AssociativeOperation{Op, resulttype(Op, arguments)}(collect(arguments))

args(operation::AssociativeOperation) = operation.arguments

map(f, operation::AssociativeOperation{Op}) where Op = AssociativeOperation{Op}(map(f, args(operation)))

opidentity(::Type{A}) where {A <: AssociativeOperation} = nothing
opidentity(::A) where {A <: AssociativeOperation} = opidentity(A)

iscommutative(::Type{A}) where {A <: AssociativeOperation} = false
iscommutative(::A) where {A <: AssociativeOperation} = iscommutative(A)

function print(io::IO, (; arguments)::AssociativeOperation{Op}) where Op
    if isempty(arguments)
        return print(io, "`EMPTY $Op`")
    end

    firstexpr, rest = Iterators.peel(arguments)

    print(io, "(")

    print(io, firstexpr)
    for expr in rest
        print(io, " $Op $expr")
    end

    print(io, ")")
end

const Sum = AssociativeOperation{+}
const Prod = AssociativeOperation{*}

const RingOps = Union{typeof(+), typeof(*)}