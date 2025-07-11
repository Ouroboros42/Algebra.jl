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

function trycombine(transform::Trivial, Op::RepeatableOps, literal1::Literal, literal2::Literal)
    @tryreturn @invoke trycombine(transform::Transform, Op, literal1, literal2)
    @tryreturn @invoke trycombine(transform, Op, literal1::Expression, literal2::Expression)
end

function trycombine(transform::Transform, Op::typeof(+), prod1::Prod, prod2::Prod)
    @tryreturn mapsome(Prod, map_single_difference((x, y) -> matchtrycombine(transform, Op, x, y), args(prod1), args(prod2)))
    @tryreturn mapsome(Prod, map_one_extra(x -> matchtrycombine(transform, Op, x, one(x)), args(prod1), args(prod2)))
end

function trycombine(transform::Trivial, Op::typeof(+), prod1::Prod, prod2::Prod)
    @tryreturn @invoke trycombine(transform, Op, prod1::Expression, prod2::Expression)
    @tryreturn @invoke trycombine(transform::Transform, Op, prod1, prod2)
end