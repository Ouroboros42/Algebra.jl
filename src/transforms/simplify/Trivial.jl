struct Trivial <: Transform end

simplify(expression::Expression) = apply(expression, Trivial())
