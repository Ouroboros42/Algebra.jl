import Base: zero, one

macro implement_algebraic_const(getconst)
    getconst = esc(getconst)

    quote
        ($getconst)(::Type{E}) where {T, E <: Expression{T}} = convert(Expression, ($getconst)(T))
        ($getconst)(::E) where {E <: Expression} = ($getconst)(E)
    end
end

@implement_algebraic_const(zero)
@implement_algebraic_const(one)