function adjacent(operation::Associative)
    central, ordered = isplitargs(operation)

    Iterators.flatten((
        preindexed_combinations(central, 2),
        adjacent(ordered),
        Iterators.product(central, ordered)
    ))
end

function trysimplify(simplifier, operation::Associative)
    if isempty(operation.arguments)
        throw(EmptyOperationError{logicaltype(operation)}())
    end

    @tryreturn @invoke trysimplify(simplifier, operation::Compound)

    # Move to trycombine
    @tryreturn firstornothing(isabsorbing(operation), operation.arguments)
    
    if any(isidentity(operation), operation.arguments)
        return similar(operation, filter(!isidentity(operation), operation.arguments), first(args(operation))) 
    end

    for ((i1, expr1), (i2, expr2)) in adjacent(operation)
        @tryreturn mapsome(matchtrycombine(simplifier, operation, expr1, expr2)) do combined
            replacesome(operation, i1 => nothing, i2 => combined)
        end
    end
end