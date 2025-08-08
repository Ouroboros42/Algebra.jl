isinteger(expression::Expression) = valtype(expression) <: Integer
isinteger(literal::Literal) = isinteger(literal.value)

isreal(expression::Expression) = valtype(expression) <: Real
isreal(literal::Literal) = isreal(literal.value)

"""
Is `expression` real and non-negative.
Returns `true` with certainty, false in all other cases.
"""
ispositive(expression::Expression) = valtype(expression) <: Unsigned
ispositive(literal::Literal{<:Real}) = literal.value >= zero(literal.value)
ispositive(sum::Union{Sum{<:Real}, Prod{<:Real}}) = all(ispositive, args(sum))

commuteunder(operation::Type{<:Compound}, a::Expression, b::Expression) = isequal(simplify(a*b == b*a), TRUE)
commutes(a, b) = commuteunder(Prod, a, b)