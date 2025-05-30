import Base: zero, one

zero(::E) where {E <: Expression} = zero(E)
one(::E) where {E <: Expression} = one(E)

zero(E::Type{<:Expression{T}}) where T = T isa Number ? ZERO : Literal(zero(T))
one(E::Type{<:Expression{T}}) where T = T isa Number ? ONE : Literal(one(T))
