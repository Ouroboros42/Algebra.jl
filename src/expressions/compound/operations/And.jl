const And = Associative{&}

isidentity(::typeof(&), element::Literal{Bool}) = element.value
isabsorbing(::typeof(&), element::Literal{Bool}) = !element.value

assoc_valtype(::typeof(&), ::Type{Bool}, ::Type{Bool}) = Bool 
