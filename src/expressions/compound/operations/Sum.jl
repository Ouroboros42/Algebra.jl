const Sum = Associative{+}

isidentity(::typeof(+), element::Expression) = iszero(element)