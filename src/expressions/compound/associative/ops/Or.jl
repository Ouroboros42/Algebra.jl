const Or = @operator Associative{|}

isidentity(::typeof(|), element::Literal{Bool}) = !element.value
isabsorbing(::typeof(|), element::Literal{Bool}) = element.value

tryinfervaltype(::Type{<:Or}, ::Type{Bool}, ::Type{Bool}) = Bool 