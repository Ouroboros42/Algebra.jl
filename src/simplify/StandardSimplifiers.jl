struct Trivial <: Simplifier end

struct MergeSame <: Simplifier end

const StandardSimplifiers = (Trivial(), MergeSame())

simplify(expression::Expression) = simplify(expression, StandardSimplifiers)
