function trycombine(::MergeSame, ::typeof(+), expr1::Expression, expr2::Expression)
    if assoc_valid(*, TWO, expr1) && isequal(expr1, expr2)
        return Prod(TWO, expr1)
    end
end

function trycombine(simplifier::MergeSame, Op::typeof(+), literal1::Literal, literal2::Literal)
    @tryreturn @invoke trycombine(simplifier, Op, literal1::Expression, literal2::Expression)
    @tryreturn @invoke trycombine(simplifier::Simplifier, Op, literal1, literal2)
end

function trycombine(simplifier::MergeSame, Op::typeof(+), prod1::Prod, prod2::Prod)
    @tryreturn @invoke trycombine(simplifier, Op, prod1::Expression, prod2::Expression)
    @tryreturn @invoke trycombine(simplifier::Simplifier, Op, prod1, prod2)
end
