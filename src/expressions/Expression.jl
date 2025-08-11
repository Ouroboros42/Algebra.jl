"""
Base type for all algebraic expressions.
"""
abstract type Expression{T} end

const Statement = Expression{Bool}

valtype(::Type{<:Expression{T}}) where T = T
valtype(::Type{<:Expression}) = nothing
valtype(::Expression{T}) where T = T

isconst(expression::Expression) = isempty(dependencies(expression))

logicaltype(expression::Expression) = typeof(expression)

"""Expression subclasses need only implement ordering withing themselves, different-type ordering is automatic."""
isless(expr1::Expression, expr2::Expression) = isless(objectid(logicaltype(expr1)), objectid(logicaltype(expr2)))

"""
Pretty-printing Expressions:
* Overload print (used by string interpolation) to define algebraic version of an expression, such that it can be included in other expressions.
* Overload 3-arg show (used by display) to display in a non-algebraic way. This falls back to print
* Generally don't overload 2-arg show, this gives a programmatic expansion, which we would like to keep.
"""
show(io::IO, ::MIME"text/plain", expression::Expression) = print(io, expression)

"""
Expressions broadcast as scalars.
"""
Base.broadcastable(expression::Expression) = Ref(expression)