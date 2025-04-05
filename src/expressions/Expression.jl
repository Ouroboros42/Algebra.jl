export Expression, valuetype
export Literal

import Base: print, show
import Base: convert

"""
Base type for all algebraic expressions.

Pretty-printing:
* Overload print (used by string interpolation) to define algebraic version of an expression, such that it can be included in other expressions.
Necessary brackets will ideally be inferred by the container.
* Overload 3-arg show (used by display) to display in a non-algebraic way. This falls back to print
"""
abstract type Expression{T} end

valuetype(::Expression{T}) where T = T

show(io::IO, ::MIME"text/plain", expression::Expression) = print(io, expression)

substitute(expression::Expression{T}; kwargs...) where T = nothing # TODO

struct Literal{T, V <: T} <: Expression{T}
    value::V
end

Literal{T}(value::V) where {T, V <: T} = Literal{T, V}(value)

print(io::IO, literal::Literal) = print(io, literal.value)
function show(io::IO, ::MIME"text/plain", literal::Literal)
    print(io, "Literal ")
    show(io, MIME("text/plain"), literal.value)
end

convert(::Type{T}, literal::Literal{T}) where T = literal.value
convert(::Type{Literal{T, V}}, value::V) where {T, V} = Literal{T}(value)
convert(::Type{Literal{T}}, value::V) where {T, V} = convert(Literal{T, V}, value)
convert(::Type{Expression{T}}, value) where T = convert(Literal{T}, value)

macro implement_algebraic_const(getconst)
    return quote
        $getconst(::Type{Expression{T}}) where T = convert(Expression{T}, $getconst(T))
        $getconst(::Expression{T}) where T = $getconst(Expression{T})
    end
end

@implement_algebraic_const(Base.zero)
@implement_algebraic_const(Base.one)