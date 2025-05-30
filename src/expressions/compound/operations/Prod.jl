const Prod = Associative{*}

hasidentity(::Prod) = true

isidentity(::Prod, element::Expression) = isone(element)