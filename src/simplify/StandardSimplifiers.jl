struct Trivial <: Simplifier end

const StandardSimplifiers = (Trivial(),)

simplify(expression::Expression) = simplify(expression, StandardSimplifiers)
