abstract type RecursiveTransform end

apply(transform) = expression -> apply(transform, expression)
tryapply(transform) = expression -> tryapply(transform, expression)

tryapply(transform, expression::Expression) = nothing

apply(transform::RecursiveTransform, expression::Expression) = @ordefault(tryapply(transform, expression), expression)
function apply(transform::RecursiveTransform, compound::Compound)
    @tryreturn tryapply(transform, compound)

    map(apply(transform), compound)
end