const Sum = Associative{+}

hasidentity(::Sum) = true

isidentity(::typeof(+), element::Expression) = iszero(element)