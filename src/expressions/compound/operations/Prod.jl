const Prod = Associative{*}

isidentity(::typeof(*), element::Expression) = isone(element)
isabsorbing(::typeof(*), element::Expression) = iszero(element)