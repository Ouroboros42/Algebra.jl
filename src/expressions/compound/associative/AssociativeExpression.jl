export AssociativeOperation, Sum, Prod

"""
An associative operation, labelled by `Op`, which is usually the equivalent julia function. 
"""
struct AssociativeOperation{Op, T} <: CompoundExpression{T}
    arguments::Vector{<:Expression}
end

AssociativeOperation{Op, T}(arguments::Expression{<:T}...) where {Op, T} = AssociativeOperation{Op}(collect(arguments))

AssociativeOperation{Op}(arguments::Vector{<:Expression}) where Op = AssociativeOperation{Op, unionise(arguments)}(arguments)
AssociativeOperation{Op}(arguments::Expression...) where Op = AssociativeOperation{Op, unionise(arguments)}(collect(arguments))

args(operation::AssociativeOperation) = operation.arguments

opidentity(::Type{A}) where {A <: AssociativeOperation} = nothing
opidentity(::A) where {A <: AssociativeOperation} = opidentity(A)

iscommutative(::Type{A}) where {A <: AssociativeOperation} = false
iscommutative(::A) where {A <: AssociativeOperation} = iscommutative(A)

function print(io::IO, (; arguments)::AssociativeOperation{Op, T}) where {Op, T}
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
