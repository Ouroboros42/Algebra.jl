abstract type Approximate <: Simplifier end

struct ApproxFloat{F <: AbstractFloat} <: Approximate end

approximate(expression::Expression, approximator::Approximate = ApproxFloat{}) = simplify(expression, StandardSimplifiers..., approximator)
