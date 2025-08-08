abstract type RecursiveTransform end

tryapply(transform::RecursiveTransform, expression::Expression) = nothing
apply(transform::RecursiveTransform, expression::Expression) = @ordefault(tryapply(transform, expression), expression)
function apply(transform::RecursiveTransform, compound::Compound)
    @tryreturn tryapply(transform, compound)

    map(apply(transform), compound)
end