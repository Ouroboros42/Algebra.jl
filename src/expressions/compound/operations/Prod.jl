const Prod = Associative{*}

hasidentity(::Prod) = true

isidentity(::typeof(*), element::Expression) = isone(element)