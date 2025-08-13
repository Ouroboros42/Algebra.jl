const Prod = @operator Associative{*}

inv(expression::Expression) = expression ^ NEG
/(first::Expression, second::Expression) = first * inv(second)
@extend_op(/)

identity(P::Type{<:Prod{T}}) where T = one(P) 
isidentity(::Type{<:Prod}, element::Expression) = isone(element)
isabsorbing(::Type{<:Prod}, element::Expression) = iszero(element)