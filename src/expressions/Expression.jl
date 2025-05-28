export Expression, valuetype
export Literal

import Base: print, show
import Base: convert
import Base: isless, ==, isequal

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

"""Expression subclasses need only implement ordering withing themselves, differernt-type ordering is automatic."""
isless(::E1, ::E2) where {E1 <: Expression, E2 <: Expression} = isless(objectid(E1), objectid(E2))

# substitute(expression::Expression{T}; kwargs...) where T = nothing # TODO