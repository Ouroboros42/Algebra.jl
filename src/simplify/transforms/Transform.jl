abstract type RecursiveTransform end

apply(transform::RecursiveTransform, expression::Expression) = @ordefault(tryapply(transform, expression), expression)
function apply(transform::RecursiveTransform, compound::Compound)
    @tryreturn tryapply(transform, compound)

    map(apply(transform), compound)
end