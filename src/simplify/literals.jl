acts_exactly(Op, value1, value2) = false

const ExactRingNumbers = Union{Integer, Rational}

acts_exactly(Op::RingOps, value1::ExactRingNumbers, value2::ExactRingNumbers) = true

"""
    apply(Op, value1, value2)

Computed value of `Op` applied to `value1` and `value2`.
Default is to call `(Op)(value1, value2)`. Overload for other behaviour. 
"""
apply(Op, value1, value2) = (Op)(value1, value2)

function trycombine(::Trivial, Op, literal1::Literal, literal2::Literal)
    if acts_exactly(Op, literal1.value, literal2.value)
        newvalue = apply(Op, literal1.value, literal2.value)

        @debug "$Op($(literal1.value), $(literal2.value)) = $(newvalue)"

        return Literal(newvalue)
    end
end