import Base: iterate, isinteger

struct Literal{T} <: Expression{T}
    value::T
end

value(literal::Literal) = literal.value

isequal(first::Literal, second::Literal) = first.value == second.value

isless(::Expression, ::Literal) = false
isless(::Literal, ::Expression) = true
isless(first::Literal, second::Literal) = isless(first.value, second.value)

print(io::IO, literal::Literal) = print(io, literal.value)
function show(io::IO, ::MIME"text/plain", literal::Literal)
    print(io, "Literal ")
    show(io, MIME("text/plain"), literal.value)
end

iterate(literal::Literal) = (literal.value, nothing)
iterate(literal::Literal, state) = nothing

const NEG = Literal(Int8(-1))
const ZERO = Literal(UInt8(0))
const ONE = Literal(UInt8(1))
const TWO = Literal(UInt8(2))