const And = @operator Associative{&, Bool}

isidentity(::typeof(&), element::Literal{Bool}) = element.value
isabsorbing(::typeof(&), element::Literal{Bool}) = !element.value