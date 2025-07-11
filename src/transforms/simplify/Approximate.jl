abstract type Approximate <: Transform end

struct ApproxFloat{F <: AbstractFloat} <: Approximate end

approximate(expression::Expression, approximator::Approximate = ApproxFloat{Float64}) = apply((Trivial, approximator), expression)
