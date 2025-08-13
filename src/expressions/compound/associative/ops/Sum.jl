const Sum = @operator Associative{+}

-(expression::Expression) = NEG * expression
-(first::Expression, second::Expression) = first + -second
@extend_op(-)

identity(S::Type{<:Sum{T}}) where T = zero(S) 
isidentity(::Type{<:Sum}, element::Expression) = iszero(element)