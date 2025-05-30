import Base: zero, one

zero(::Type{E}) where {T, E <: Expression{T}} = T isa Number ? ZERO : Literal(zero(T))
one(::Type{E}) where {T, E <: Expression{T}} = T isa Number ? ONE : Literal(one(T))
