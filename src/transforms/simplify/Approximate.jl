abstract type Approximate <: Simplifier end

struct ApproxFloat{F <: AbstractFloat} <: Approximate end

approximate(expression::Expression, approximator::Approximate) = apply(chain(Trivial(), approximator), expression)
approximate(expression::Expression, floattype::Type = Float64) = approximate(expression, ApproxFloat{floattype}())