"""
Transform `args` first, then apply `transform` to whole expression.
"""
function apply(transform::Transform, compound::Compound)
    argstransformed = map(apply(transform), compound)

    @invoke apply(transform, argstransformed::Expression)
end