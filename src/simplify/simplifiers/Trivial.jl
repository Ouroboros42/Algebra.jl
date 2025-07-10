struct Trivial <: Simplifier end

simplify(expression::Expression) = simplify(expression, Trivial())
