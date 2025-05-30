import Base: iszero, isone

const Sum = Associative{+}
const Prod = Associative{*}

const RingOps = Union{typeof(+), typeof(*)}

macro implement_constcheck(constcheck)
    constcheck = esc(constcheck)

    quote
        ($constcheck)(::Expression) = false
        ($constcheck)(literal::Literal) = ($constcheck)(literal.value)
    end
end

@implement_constcheck(iszero)
@implement_constcheck(isone)

hasidentity(::Sum) = true
hasidentity(::Prod) = true

isidentity(::Sum, element::Expression) = iszero(element)
isidentity(::Prod, element::Expression) = isone(element)