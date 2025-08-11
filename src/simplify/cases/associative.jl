matchingforms(simplifier, ::Type{<:Sum}, target::Prod, initial::Expression) = (Prod(initial),)
matchingforms(simplifier, ::Type{<:Prod}, target::Sum, initial::Expression) = (Sum(initial),)

isnested(assoc::Associative) = isinst(logicaltype(assoc))

toargs(assoc::Type{<:Associative}, expr::Expression) = expr isa assoc ? args(expr) : [ expr ]
toargs(assoc) = expr -> toargs(assoc, expr)
toargs(operation::Associative) = toargs(logicaltype(operation))

flatten(operation::Associative) = similar(operation, Iterators.flatmap(toargs(operation), args(operation)))

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

    @tryreturn onlyornothing(operation.arguments)

    if any(isnested(operation), operation.arguments)
        return flatten(operation)
    end

    @tryreturn @invoke trysimplify(simplifier, operation::Compound)

    # Move to trycombine
    @tryreturn firstornothing(isabsorbing(operation), operation.arguments)
    
    if any(isidentity(operation), operation.arguments)
        return similar(operation, filter(!isidentity(operation), operation.arguments), first(args(operation))) 
    end
    
    @tryreturn trysort(operation, CentralFirst(operation))

    for ((i1, expr1), (i2, expr2)) in adjacent(operation)
        @tryreturn mapsome(matchtrycombine(simplifier, operation, expr1, expr2)) do combined
            replacesome(operation, i1 => nothing, i2 => combined)
        end
    end
end