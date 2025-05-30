const Sum = Associative{+}

hasidentity(::Sum) = true

isidentity(::Sum, element::Expression) = iszero(element)