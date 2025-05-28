export Expression
export Literal

import Base: isless, isequal
import Base: valtype
import Base: print, show

"""
Base type for all algebraic expressions.
"""
abstract type Expression{T} end

valtype(::Type{E}) where {T, E <: Expression{T}} = T
valtype(::Type{E}) where {E <: Expression} = nothing
valtype(::Expression{T}) where T = T

"""Expression subclasses need only implement ordering withing themselves, differernt-type ordering is automatic."""
isless(::E1, ::E2) where {E1 <: Expression, E2 <: Expression} = isless(objectid(E1), objectid(E2))

"""
Pretty-printing:
* Overload print (used by string interpolation) to define algebraic version of an expression, such that it can be included in other expressions.
Necessary brackets will ideally be inferred by the container.
* Overload 3-arg show (used by display) to display in a non-algebraic way. This falls back to print
* Generally don't overload 2-arg show, this gives a programmatic expansion.
"""

show(io::IO, ::MIME"text/plain", expression::Expression) = print(io, expression)
