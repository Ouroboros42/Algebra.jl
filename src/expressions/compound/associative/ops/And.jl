const And = @operator Associative{&, Bool}

isidentity(::Type{<:And}, element::Literal{Bool}) = element.value
isabsorbing(::Type{<:And}, element::Literal{Bool}) = !element.value