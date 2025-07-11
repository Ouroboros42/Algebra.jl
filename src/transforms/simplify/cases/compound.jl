"""
Transform `args` first, then apply `transforms` to whole expression.
"""
function apply(transforms::NTuple{N, Transform}, compound::Compound) where N
    argstransformed = map(apply(transforms), compound)

    @invoke apply(transforms, argstransformed::Expression)
end