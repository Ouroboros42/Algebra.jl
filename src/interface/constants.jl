import Base: zero, one

macro implement_algebraic_const(getconst)
    getconst = esc(getconst)

    quote
        ($getconst)(::Type{E}) where {E <: Expression} = express(($getconst)(valtype(E)))
        ($getconst)(::Type{E}) where {E <: Expression{<:Number}} = express(($getconst)(Int8))
        ($getconst)(::E) where {E <: Expression} = ($getconst)(E)
    end
end

@implement_algebraic_const(zero)
@implement_algebraic_const(one)