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
function show(io::IO, ::MIME"text/plain", literal::Literal)
    print(io, "Literal ")
    show(io, MIME("text/plain"), literal.value)
end