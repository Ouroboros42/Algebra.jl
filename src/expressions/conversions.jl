Expression(value) = convert(Expression, value)

convert(::Type{T}, literal::Literal{<:T}) where T = literal.value

convert(::Type{>:Literal{T}}, value::T) where T = Literal(value)
convert(::Type{>:Literal{T}}, literal::Literal{T}) where T = literal
convert(::Type{>:Expression}, expr::Expression) = expr
convert(::Type{>:Expression}, literal::Literal) = literal
