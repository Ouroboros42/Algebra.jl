abstract type Transform end

tryapply(::Transform, ::Expression) = nothing
tryapply(transform::Transform) = expression::Expression -> tryapply(transform, expression)

"""
Transform `args` first, then apply `transform` to whole expression.
"""
tryapply(transform::Transform, compound::Compound) = mapfirst(tryapply(transform), compound)

apply(transform::Transform, expression::Expression) = @ordefault(tryapply(transform, expression), expression)

apply(transform::Transform) = expression -> apply(transform, expression)