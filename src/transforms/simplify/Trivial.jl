struct Trivial <: Simplifier end

simplify(expression::Expression) = apply(Trivial(), expression)
