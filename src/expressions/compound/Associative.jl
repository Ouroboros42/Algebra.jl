import Base: similar

"""
An associative operation, labelled by `Op`, which is usually the equivalent julia function. 
"""
struct Associative{Op, T, E <: Expression} <: CompoundExpression{T}
    arguments::Vector{E}
end

Associative{Op, T}(arguments::Vector{E}) where {Op, T, E} = Associative{Op, T, E}(arguments)

Associative{Op}(arguments::Vector{<:Expression}) where Op = Associative{Op, assoc_valtype(Op, arguments)}(arguments)
Associative{Op}(arguments::Expression...) where Op = Associative{Op, assoc_valtype(Op, arguments)}(collect(arguments))

similar(::Associative{Op}, arguments...) where Op = Associative{Op}(arguments...)
args(operation::Associative) = operation.arguments

iscommutative(::Type{A}) where {A <: Associative} = false
iscommutative(::A) where {A <: Associative} = iscommutative(A)

hasidentity(Op) = false

isidentity(::Type{A}, ::Expression) where {A <: Associative} = false
isidentity(::A, expression::Expression) where {A <: Associative} = isidentity(A, expression)
isidentity(operation::Associative) = element -> isidentity(operation, element)

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
