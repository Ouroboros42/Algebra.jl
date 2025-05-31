function trycombine(simplifier::Simplifier, Op, operation::Associative, single::Expression)
    trycombine(simplifier, Op, operation, similar(operation, single))
end

function trycombine(simplifier::Simplifier, Op, single::Expression, operation::Associative)
    trycombine(simplifier, Op, similar(operation, single), operation)
end

trycombine(simplifier::Simplifier, Op, op1::Associative{AOp}, op2::Associative{AOp}) where AOp = @invoke trycombine(simplifier, Op, op1::Expression, op2::Expression)

function trycombine(simplifier::Simplifier, Op, op1::Associative, op2::Associative)
    @tryreturn @invoke trycombine(simplifier, Op, op1, op2::Expression)
    @tryreturn @invoke trycombine(simplifier, Op, op1::Expression, op2)
end