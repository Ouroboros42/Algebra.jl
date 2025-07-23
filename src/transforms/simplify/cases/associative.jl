import Combinat: Combinations

matchingforms(::Simplifier, ::Type{<:Sum}, target::Prod, initial::Expression) = (similar(target, initial),)

isnested(assoc::Associative) = isinst(logicaltype(assoc))

toargs(::Associative, expr::Expression) = [ expr ]
toargs(::Associative{Op}, expr::Associative{Op}) where Op = expr.arguments
toargs(operation) = expr -> toargs(operation, expr) 

flatten(operation::Associative) = similar(operation, collect(Iterators.flatmap(toargs(operation), args(operation))))

function combinable(operation::Associative)
    central, ordered = isplitargs(operation)

    Iterators.flatten((
        Combinations(central, 2),
        adjacent(ordered),
        Iterators.product(central, ordered)
    ))
end

function tryapply(simplifier::Simplifier, operation::Associative)
    for ((i1, expr1), (i2, expr2)) in combinable(operation)
        @tryreturn mapsome(matchtrycombine(simplifier, operation, expr1, expr2)) do combined
            replacesomeargs(operation, i1 => nothing, i2 => combined)
        end
    end
end

function tryapply(simplifier::Trivial, operation::Associative)
    if isempty(operation.arguments)
        throw(EmptyOperationError{op(operation)}())
    end

    @tryreturn onlyornothing(operation.arguments)

    if any(isnested(operation), operation.arguments)
        return flatten(operation)
    end

    @tryreturn firstornothing(isabsorbing(operation), operation.arguments)
    
    if any(isidentity(operation), operation.arguments)
        return similar(operation, filter(!isidentity(operation), operation.arguments)) 
    end
    
    @tryreturn trysort(operation, CentralFirst(operation))

    @tryreturn @invoke tryapply(simplifier::Simplifier, operation)
end

trysort(operation::Associative, order::Ordering) = if !issorted(operation.arguments; order)
    similar(operation, sort(operation.arguments; order))
end