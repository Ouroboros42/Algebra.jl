"""
Transform `args` first, then apply `transforms` to whole expression.
"""
function apply(compound::Compound, transforms::NTuple{N, Transform}) where N
    argstransformed = map(apply(transforms), compound)

    @invoke apply(argstransformed::Expression, transforms)
end