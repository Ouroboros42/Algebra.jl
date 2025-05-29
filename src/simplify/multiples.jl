"""
    supportsintmul(::Type{E}) where {T, E <: Expression{T}}

Evaluate if the given type accepts multiplication with integers, for simplifying sums.
"""
supportsintmul(::Type{E}) where {T, E <: Expression{T}} = !isnothing(resulttype(*, Int8, T))
supportsintmul(::E) where {E <: Expression} = supportsintmul(E)

const LITERAL_TWO = Literal(Int8(2))

function trycombine(::MergeSame, ::typeof(+), expr1::Expression, expr2::Expression)
    if supportsintmul(expr1) && isequal(expr1, expr2)
        return Prod(LITERAL_TWO, expr1)
    end
end

function trycombine(simplifier::Simplifier, Op, operation::A, single::Expression) where {AOp, A <: Associative{AOp}}
    trycombine(simplifier, Op, operation, Associative{AOp}(single))
end

function trycombine(simplifier::Simplifier, Op, single::Expression, operation::A) where {AOp, A <: Associative{AOp}}
    trycombine(simplifier, Op, Associative{AOp}(single), operation)
end

trycombine(simplifier::Simplifier, Op, op1::A1, op2::A2) where {AOp, A1 <: Associative{AOp}, A2 <: Associative{AOp}} = @invoke trycombine(simplifier, Op, op1::Expression, op2::Expression)
function trycombine(simplifier::Simplifier, Op, op1::Associative, op2::Associative)
    @tryreturn @invoke trycombine(simplifier, Op, op1, op2::Expression)
    @tryreturn @invoke trycombine(simplifier, Op, op1::Expression, op2)
end

trycombine(simplifier::MergeSame, Op::typeof(+), operation::A, single::Expression) where {A <: Associative} = @invoke trycombine(simplifier::Simplifier, Op, operation, single) 
trycombine(simplifier::MergeSame, Op::typeof(+), single::Expression, operation::A) where {A <: Associative} = @invoke trycombine(simplifier::Simplifier, Op, single, operation) 

function trycombine(simplifier::Simplifier, ::typeof(+), prod1::Prod, prod2::Prod)
    @tryreturn mapsome(Prod, map_single_difference((x, y) -> trycombine(simplifier, +, x, y), args(prod1), args(prod2)))
    @tryreturn mapsome(Prod, map_one_extra(x -> trycombine(simplifier, +, x, one(x)), args(prod1), args(prod2)))
end

function trycombine(simplifier::MergeSame, Op::typeof(+), prod1::Prod, prod2::Prod)
    @tryreturn @invoke trycombine(simplifier::MergeSame, Op::typeof(+), prod1::Expression, prod2::Expression)
    @tryreturn @invoke trycombine(simplifier::Simplifier, Op, prod1, prod2)
end
