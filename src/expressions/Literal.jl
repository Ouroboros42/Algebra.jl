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

const NEG = Literal(Int8(-1))
const ZERO = Literal(UInt8(0))
const ONE = Literal(UInt8(1))
const TWO = Literal(UInt8(2))