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

trycombine(simplifier::MergeSame, Op::RepeatableOps, operation::A, single::Expression) where {A <: Associative} = @invoke trycombine(simplifier::Simplifier, Op, operation, single) 
trycombine(simplifier::MergeSame, Op::RepeatableOps, single::Expression, operation::A) where {A <: Associative} = @invoke trycombine(simplifier::Simplifier, Op, single, operation) 

function trycombine(simplifier::MergeSame, Op::RepeatableOps, literal1::Literal, literal2::Literal)
    @tryreturn @invoke trycombine(simplifier, Op, literal1::Expression, literal2::Expression)
    @tryreturn @invoke trycombine(simplifier::Simplifier, Op, literal1, literal2)
end

function trycombine(simplifier::MergeSame, Op::typeof(+), prod1::Prod, prod2::Prod)
    @tryreturn @invoke trycombine(simplifier, Op, prod1::Expression, prod2::Expression)
    @tryreturn @invoke trycombine(simplifier::Simplifier, Op, prod1, prod2)
end
