const RepeatableOps = Union{typeof(+), typeof(*)}

repeat_assoc_op(::typeof(+)) = Prod
repeat_assoc_op(::typeof(*)) = Pow 

function trycombine(::Trivial, Op::RepeatableOps, expr1::Expression, expr2::Expression)
    mapsome(repeat_assoc_op(Op)) do repeated
        if isvalid(repeated, expr1, TWO) && isequal(expr1, expr2)
            return repeated(expr1, TWO)
        end
    end
end

function trycombine(simplifier::Trivial, Op::RepeatableOps, literal1::Literal, literal2::Literal)
    @tryreturn @invoke trycombine(simplifier::Simplifier, Op, literal1, literal2)
    @tryreturn @invoke trycombine(simplifier, Op, literal1::Expression, literal2::Expression)
end

function trycombine(simplifier::Simplifier, Op::typeof(+), prod1::Prod, prod2::Prod)
    @tryreturn mapsome(Prod, map_single_difference((x, y) -> matchtrycombine(simplifier, Op, x, y), args(prod1), args(prod2)))
    @tryreturn mapsome(Prod, map_one_extra(x -> matchtrycombine(simplifier, Op, x, one(x)), args(prod1), args(prod2)))
end

function trycombine(simplifier::Trivial, Op::typeof(+), prod1::Prod, prod2::Prod)
    @tryreturn @invoke trycombine(simplifier, Op, prod1::Expression, prod2::Expression)
    @tryreturn @invoke trycombine(simplifier::Simplifier, Op, prod1, prod2)
end