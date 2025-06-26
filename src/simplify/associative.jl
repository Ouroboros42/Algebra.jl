import Combinat: Combinations

"""
    trycombine(simplifier::Simplifier, Op, expression1::Expression, expression2::Expression)

Override for types which can be combined together under the given operation."""
trycombine(::Simplifier, Op, ::Expression, ::Expression) = nothing

isnested(::Associative{Op}) where Op = isinst(Associative{Op})

toargs(::Associative, expr::Expression) = [ expr ]
toargs(::Associative{Op}, expr::Associative{Op}) where Op = expr.arguments
toargs(op) = expr -> toargs(op, expr) 

function flatten(operation::Associative)
    similar(operation, collect(Iterators.flatmap(toargs(operation), args(operation))))
end

debugtrycombine(simplifier, Op, expr1, expr2) = forsome(trycombine(simplifier, Op, expr1, expr2)) do combined
    @debug "Combined $Op($expr1, $expr2) -> $combined"
end

function trysimplify(operation::Associative{Op}, simplifier::Simplifier) where Op
    splitopargs = isplitargs(operation)
    central, ordered = splitopargs
    anycentral, anyordered = @. !isempty(splitopargs)

    if anycentral
        for ((i1, expr1), (i2, expr2)) in Combinations(central, 2)
            @tryreturn mapsome(debugtrycombine(simplifier, Op, expr1, expr2)) do combined
                replacesomeargs(operation, i1 => combined, i2 => nothing)
            end
        end
    end
    
    if anyordered
        for ((i1, expr1), (i2, expr2)) in adjacent(ordered)
            @tryreturn mapsome(debugtrycombine(simplifier, Op, expr1, expr2)) do combined
                replacesomeargs(operation, i1 => combined, i2 => nothing)
            end
        end
    end

    if anycentral && anyordered
        for ((icentral, centralexpr), (iordered, orderedexpr)) in Iterators.product(central, ordered)
            @tryreturn mapsome(debugtrycombine(simplifier, Op, centralexpr, orderedexpr)) do combined
                replacesomeargs(operation, icentral => nothing, iordered => combined)
            end
        end
    end
end

function trysimplify(operation::Associative{Op, T}, simplifier::Trivial) where {Op, T}
    if isempty(operation.arguments)
        throw(EmptyOperationError{Op}())
    end

    @tryreturn onlyornothing(operation.arguments)

    if any(isnested(operation), operation.arguments)
        return flatten(operation)
    end

    if operation isa Prod
        @tryreturn firstornothing(iszero, operation.arguments)
    end

    if any(isidentity(operation), operation.arguments)
        return Associative{Op, T}(filter(!isidentity(operation), operation.arguments)) 
    end
    
    @tryreturn trysort(operation, CentralFirst(operation))

    @tryreturn @invoke trysimplify(operation, simplifier::Simplifier)
end

trysort(operation::Associative, order::Ordering) = if !issorted(operation.arguments; order)
    similar(operation, sort(operation.arguments; order))
end