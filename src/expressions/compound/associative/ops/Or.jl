const Or = @operator Associative{|, Bool}

isidentity(::Type{<:Or}, element::Literal{Bool}) = !element.value
isabsorbing(::Type{<:Or}, element::Literal{Bool}) = element.value
