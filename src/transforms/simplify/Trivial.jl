struct Trivial <: Transform end

simplify(expression::Expression) = apply(Trivial(), expression)
