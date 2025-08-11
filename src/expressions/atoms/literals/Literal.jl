struct Literal{T} <: Expression{T}
    value::T
end

value(literal::Literal) = literal.value

isequal(first::Literal, second::Literal) = first.value == second.value
hash(literal::Literal, h::UInt) = hash(literal.value, h)

isless(::Expression, ::Literal) = false
isless(::Literal, ::Expression) = true
isless(first::Literal, second::Literal) = isless(first.value, second.value)

print(io::IO, literal::Literal) = print(io, literal.value)

dependencies(::Literal) = Dependencies()