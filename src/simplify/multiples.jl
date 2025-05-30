function trycombine(::MergeSame, ::typeof(+), expr1::Expression, expr2::Expression)
    if assoc_valid(*, TWO, expr1) && isequal(expr1, expr2)
        return Prod(TWO, expr1)
    end
end

function trycombine(simplifier::MergeSame, Op::typeof(+), prod1::Prod, prod2::Prod)
    @tryreturn @invoke trycombine(simplifier::MergeSame, Op::typeof(+), prod1::Expression, prod2::Expression)
    @tryreturn @invoke trycombine(simplifier::Simplifier, Op, prod1, prod2)
end
