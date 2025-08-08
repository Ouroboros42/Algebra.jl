const TRUE = Literal(true)
const FALSE = Literal(false)

const NEG = Literal(Int8(-1))
const ZERO = Literal(UInt8(0))
const ONE = Literal(UInt8(1))
const TWO = Literal(UInt8(2))
const HALF = Literal(UInt8(1)//UInt8(2))

macro implement_getconst(getconst)
    getconst = esc(getconst)

    quote
        ($getconst)(expression::Expression) = ($getconst)(typeof(expression))
        ($getconst)(E::Type{<:Expression}) = Literal(($getconst)(valtype(E)))
    end
end

macro implement_constcheck(constcheck)
    constcheck = esc(constcheck)

    quote
        ($constcheck)(::Expression) = false
        ($constcheck)(literal::Literal) = ($constcheck)(literal.value)
    end
end

@implement_getconst(zero)
@implement_getconst(one)

@implement_constcheck(iszero)
@implement_constcheck(isone)

"""Backup zero for better compatibility with array operations."""
zero(::Type{Expression}) = ZERO