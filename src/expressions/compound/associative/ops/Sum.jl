const Sum = Associative{+}
@implement_assoc_op(+)

-(expression::Expression) = NEG * expression
-(first::Expression, second::Expression) = first + -second
@extend_binary_op(-)


isidentity(::typeof(+), element::Expression) = iszero(element)