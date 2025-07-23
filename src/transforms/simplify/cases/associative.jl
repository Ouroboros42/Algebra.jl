import Combinat: Combinations

matchingforms(::Simplifier, ::Type{<:Sum}, target::Prod, initial::Expression) = (similar(target, initial),)

isnested(assoc::Associative) = isinst(logicaltype(assoc))

toargs(::Associative, expr::Expression) = [ expr ]
toargs(::Associative{Op}, expr::Associative{Op}) where Op = expr.arguments
toargs(operation) = expr -> toargs(operation, expr) 

flatten(operation::Associative) = similar(operation, collect(Iterators.flatmap(toargs(operation), args(operation))))

function tryapply(simplifier::Simplifier, operation::Associative)
    splitopargs = isplitargs(operation)
    central, ordered = splitopargs
    anycentral, anyordered = @. !isempty(splitopargs)

    if anycentral
        for ((i1, expr1), (i2, expr2)) in Combinations(central, 2)
            @tryreturn mapsome(matchtrycombine(simplifier, operation, expr1, expr2)) do combined
                replacesomeargs(operation, i1 => combined, i2 => nothing)
            end
        end
    end
    
    if anyordered
        for ((i1, expr1), (i2, expr2)) in adjacent(ordered)
            @tryreturn mapsome(matchtrycombine(simplifier, operation, expr1, expr2)) do combined
                replacesomeargs(operation, i1 => combined, i2 => nothing)
            end
        end
    end

    if anycentral && anyordered
        for ((icentral, centralexpr), (iordered, orderedexpr)) in Iterators.product(central, ordered)
            @tryreturn mapsome(matchtrycombine(simplifier, logicaltype(operation), centralexpr, orderedexpr)) do combined
                replacesomeargs(operation, icentral => nothing, iordered => combined)
            end
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