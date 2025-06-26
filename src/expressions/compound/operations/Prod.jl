const Prod = Associative{*}

isidentity(::typeof(*), element::Expression) = isone(element)