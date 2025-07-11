const Prod = @operator Associative{*}

inv(expression::Expression) = expression ^ NEG
/(first::Expression, second::Expression) = first * inv(second)
@extend_binary_op(/)

isidentity(::typeof(*), element::Expression) = isone(element)
isabsorbing(::typeof(*), element::Expression) = iszero(element)