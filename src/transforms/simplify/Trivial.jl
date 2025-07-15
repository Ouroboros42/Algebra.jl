struct Trivial <: Simplifier end

const TRIVIAL_CHAIN = chain(Trivial())

simplify(expression::Expression) = apply(TRIVIAL_CHAIN, expression)
