const Sum = @operator Associative{+}

-(expression::Expression) = NEG * expression
-(first::Expression, second::Expression) = first + -second
@extend_op(-)

isidentity(::typeof(+), element::Expression) = iszero(element)