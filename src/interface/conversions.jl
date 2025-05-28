import Base: convert

convert(::Type{T}, literal::Literal{<:T}) where T = literal.value

convert(::Type{>:Literal{T}}, value::T) where T = Literal(value)
convert(::Type{>:Expression}, expr::Expression) = expr