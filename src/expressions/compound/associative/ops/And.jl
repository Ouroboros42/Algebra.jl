const And = @operator Associative{&}

isidentity(::typeof(&), element::Literal{Bool}) = element.value
isabsorbing(::typeof(&), element::Literal{Bool}) = !element.value

tryinfervaltype(::Type{<:And}, ::Type{Bool}, ::Type{Bool}) = Bool