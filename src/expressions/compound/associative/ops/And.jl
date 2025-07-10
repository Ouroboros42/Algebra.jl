const And = Associative{&}

@implement_assoc_op(&)

isidentity(::typeof(&), element::Literal{Bool}) = element.value
isabsorbing(::typeof(&), element::Literal{Bool}) = !element.value

assoc_valtype(::typeof(&), ::Type{Bool}, ::Type{Bool}) = Bool 
