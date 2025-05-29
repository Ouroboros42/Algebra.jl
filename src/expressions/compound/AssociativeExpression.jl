"""
An associative operation, labelled by `Op`, which is usually the equivalent julia function. 
"""
struct Associative{Op, T, E <: Expression} <: CompoundExpression{T}
    arguments::Vector{E}
end

Associative{Op, T}(arguments::Vector{E}) where {Op, T, E} = Associative{Op, T, E}(arguments)

Associative{Op}(arguments::Vector{<:Expression}) where Op = Associative{Op, resulttype(Op, arguments)}(arguments)
Associative{Op}(arguments::Expression...) where Op = Associative{Op, resulttype(Op, arguments)}(collect(arguments))
sameop(::Associative{Op}, arguments...) where Op = Associative{Op}(arguments...)

args(operation::Associative) = operation.arguments

map(f, operation::Associative) = sameop(operation, map(f, args(operation)))

iscommutative(::Type{A}) where {A <: Associative} = false
iscommutative(::A) where {A <: Associative} = iscommutative(A)

function print(io::IO, (; arguments)::Associative{Op}) where Op
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

const Sum = Associative{+}
const Prod = Associative{*}

const RingOps = Union{typeof(+), typeof(*)}