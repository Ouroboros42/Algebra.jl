"""
Simplify `args` first, then apply simplifications to whole expression.
"""
function simplify(compound::Compound, simplifiers::NTuple{N, Simplifier}) where N
    argssimplified = map(simplifywith(simplifiers), compound)

    @invoke simplify(argssimplified::Expression, simplifiers)
end