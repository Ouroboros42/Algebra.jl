abstract type Approximate <: Simplifier end

struct ApproxFloat{F <: AbstractFloat} <: Approximate end

approximate(expression::Expression, approximator::Approximate = ApproxFloat{Float64}) = simplify(expression, Trivial, approximator)
