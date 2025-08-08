struct Partial{V<:Variable} <: Derivation
    by::V
end

apply(partial::Partial, var::Variable) = ifelse(isequal(partial.by, var), one(var), zero(var))

export derivative
derivative(var::Variable, expression::Expression) = simplify(apply(Partial(var), expression))