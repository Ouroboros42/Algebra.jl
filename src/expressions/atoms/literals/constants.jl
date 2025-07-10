const NEG = Literal(Int8(-1))
const ZERO = Literal(UInt8(0))
const ONE = Literal(UInt8(1))
const TWO = Literal(UInt8(2))

zero(::E) where {E <: Expression} = zero(E)
one(::E) where {E <: Expression} = one(E)

zero(::Type{<:Expression{T}}) where T = T isa Number ? ZERO : Literal(zero(T))
one(::Type{<:Expression{T}}) where T = T isa Number ? ONE : Literal(one(T))
