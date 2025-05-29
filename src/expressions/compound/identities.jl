import Base: iszero, isone

macro implement_constcheck(constcheck)
    constcheck = esc(constcheck)

    quote
        ($constcheck)(::Expression) = false
        ($constcheck)(literal::Literal) = ($constcheck)(literal.value)
    end
end

@implement_constcheck(iszero)
@implement_constcheck(isone)

hasidentity(Op) = false

hasidentity(::Sum) = true
hasidentity(::Prod) = true

isidentity(::AssociativeOperation, ::Expression) = false
isidentity(operation::AssociativeOperation) = element -> isidentity(operation, element)

isidentity(::Sum, element::Expression) = iszero(element)
isidentity(::Prod, element::Expression) = isone(element)