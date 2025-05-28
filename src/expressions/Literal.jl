struct Literal{T} <: Expression{T}
    value::T
end

isequal(first::Literal, second::Literal) = first.value == second.value
isless(first::Literal, second::Literal) = isless(first.value, second.value)

print(io::IO, literal::Literal) = print(io, literal.value)
function show(io::IO, ::MIME"text/plain", literal::Literal)
    print(io, "Literal ")
    show(io, MIME("text/plain"), literal.value)
end
