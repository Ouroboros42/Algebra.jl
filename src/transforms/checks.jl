import Base: iszero, isone, isinteger

macro implement_constcheck(constcheck)
    constcheck = esc(constcheck)

    quote
        ($constcheck)(::Expression) = false
        ($constcheck)(literal::Literal) = ($constcheck)(literal.value)
    end
end

@implement_constcheck(iszero)
@implement_constcheck(isone)

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