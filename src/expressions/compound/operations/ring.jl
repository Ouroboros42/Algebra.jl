import Base: iszero, isone

const Sum = Associative{+}
const Prod = Associative{*}

const RingOps = Union{typeof(+), typeof(*)}

hasidentity(::Sum) = true
hasidentity(::Prod) = true

macro implement_constcheck(constcheck)
    constcheck = esc(constcheck)

    quote
        ($constcheck)(::Expression) = false
        ($constcheck)(literal::Literal) = ($constcheck)(literal.value)
    end
end

@implement_constcheck(iszero)
@implement_constcheck(isone)

isidentity(::Sum, element::Expression) = iszero(element)
isidentity(::Prod, element::Expression) = isone(element)