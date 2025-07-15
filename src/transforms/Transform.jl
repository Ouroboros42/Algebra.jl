abstract type Transform end

tryapply(::Transform, ::Expression) = nothing

apply(transform::Transform, expression::Expression) = @ordefault(tryapply(transform, expression), expression)

apply(transform) = expression -> apply(transform, expression)