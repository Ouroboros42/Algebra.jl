export AssociativeOperation, Sum, Prod

abstract type CompoundExpression{T} <: Expression{T} end

struct AssociativeOperation{Op, T} <: CompoundExpression{T}
    arguments::Vector{Expression{T}}
end

AssociativeOperation{Op}(arguments::Vector{<:Expression{T}}) where {Op, T} = AssociativeOperation{Op, T}(arguments)

iscommutative(::Type{A}) where {A <: AssociativeOperation} = false
args(operation::AssociativeOperation) = operation.arguments

function print(io::IO, (; arguments)::AssociativeOperation{Op, T}) where {Op, T}
    if isempty(arguments)
        return print(io, "`EMPTY $Op`")
    end

    firstexpr, rest = Iterators.peel(arguments)

    print(io, "(")

    print(io, firstexpr)
    for expr in rest
        print(io, " $Op ", expr)
    end

    print(io, ")")
end

const Sum = AssociativeOperation{+}
const Prod = AssociativeOperation{*}

const FieldVal = Union{Real, Complex}
const RingVal = Union{FieldVal, Array{<:FieldVal}}

iscommutative(::Type{S}) where {S <: Sum{<:RingVal}} = true
iscommutative(::Type{P}) where {P <: Prod{<:FieldVal}} = true

macro implement_algebraic_op(OP)
    return quote
        local A = AssociativeOperation{$OP}

        $OP(args::Expression...) = simplify(A(collect(args)))

        $OP(expr::Expression{T}, value::T) where T = $OP(expr, convert(Expression{T}, value))
        $OP(value::T, expr::Expression{T}) where T = $OP(convert(Expression{T}, value), expr)
    end
end

@implement_algebraic_op(Base.:+)
@implement_algebraic_op(Base.:*)