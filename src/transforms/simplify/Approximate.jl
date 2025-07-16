abstract type Approximate <: Simplifier end

struct FloatApprox{F <: AbstractFloat} <: Approximate end

approximate(expression::Expression, floattype = Float64) = apply(FloatApprox{floattype}(), expression)