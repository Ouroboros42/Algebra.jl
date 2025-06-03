const RepeatableOps = Union{typeof(+), typeof(*)}

repeat_assoc_op(::typeof(+)) = Prod
repeat_assoc_op(::typeof(*)) = Pow 

function trycombine(::MergeSame, Op::RepeatableOps, expr1::Expression, expr2::Expression)
    mapsome(repeat_assoc_op(Op)) do repeated
        if isvalid(repeated, expr1, TWO) && isequal(expr1, expr2)
            return repeated(expr1, TWO)
        end
    end
end

trycombine(simplifier::MergeSame, Op::RepeatableOps, operation::Associative, single::Expression) = @invoke trycombine(simplifier::Simplifier, Op, operation, single) 
trycombine(simplifier::MergeSame, Op::RepeatableOps, single::Expression, operation::Associative) = @invoke trycombine(simplifier::Simplifier, Op, single, operation) 
function trycombine(simplifier::MergeSame, Op::RepeatableOps, assoc1::Associative{AOp}, assoc2::Associative{AOp}) where AOp
    @invoke trycombine(simplifier, Op, assoc1::Expression, assoc2::Expression)
    @invoke trycombine(simplifier::Simplifier, Op, assoc1, assoc2)
end

function trycombine(simplifier::MergeSame, Op::RepeatableOps, literal1::Literal, literal2::Literal)
    @tryreturn @invoke trycombine(simplifier, Op, literal1::Expression, literal2::Expression)
    @tryreturn @invoke trycombine(simplifier::Simplifier, Op, literal1, literal2)
end

function trycombine(simplifier::Simplifier, Op::typeof(+), prod1::Prod, prod2::Prod)
    @tryreturn mapsome(Prod, map_single_difference((x, y) -> trycombine(simplifier, Op, x, y), args(prod1), args(prod2)))
    @tryreturn mapsome(Prod, map_one_extra(x -> trycombine(simplifier, Op, x, one(x)), args(prod1), args(prod2)))
end

function trycombine(simplifier::MergeSame, Op::typeof(+), prod1::Prod, prod2::Prod)
    @tryreturn @invoke trycombine(simplifier, Op, prod1::Expression, prod2::Expression)
    @tryreturn @invoke trycombine(simplifier::Simplifier, Op, prod1, prod2)
end