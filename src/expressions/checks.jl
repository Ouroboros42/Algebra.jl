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