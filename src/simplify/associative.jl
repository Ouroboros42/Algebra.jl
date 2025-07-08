import Combinat: Combinations

"""
Override for types which can be combined together under the given operation.
Returns `nothing` if no simplified combination is possible.
"""
trycombine(::Simplifier, Op, ::Expression, ::Expression) = nothing

"""
Override if `initial` has equivalent forms more suitable to combine with `target`.
Returns a sequence of all possible forms.
"""
matchingforms(::Simplifier, Op, target::Expression, initial::Expression) = ()
matchingforms(::Simplifier, Op, operation::Associative, single::Expression) = (similar(operation, single),)

function matchtrycombine(simplifier::Simplifier, Op, expr1::Expression, expr2::Expression)
    @tryreturn trycombine(simplifier, Op, expr1, expr2)

    for form2 in matchingforms(simplifier, Op, expr1, expr2)
        @tryreturn trycombine(simplifier, Op, expr1, form2)
    end

    for form1 in matchingforms(simplifier, Op, expr2, expr1)
        @tryreturn trycombine(simplifier, Op, form1, expr2)
    end
end

debugmatchtrycombine(simplifier, Op, expr1, expr2) = forsome(matchtrycombine(simplifier, Op, expr1, expr2)) do combined
    @debug "Combined using $simplifier: $Op($expr1, $expr2) -> $combined"
end

isnested(::Associative{Op}) where Op = isinst(Associative{Op})

toargs(::Associative, expr::Expression) = [ expr ]
toargs(::Associative{Op}, expr::Associative{Op}) where Op = expr.arguments
toargs(op) = expr -> toargs(op, expr) 

flatten(operation::Associative) = similar(operation, collect(Iterators.flatmap(toargs(operation), args(operation))))

function trysimplify(operation::Associative{Op}, simplifier::Simplifier) where Op
    splitopargs = isplitargs(operation)
    central, ordered = splitopargs
    anycentral, anyordered = @. !isempty(splitopargs)

    if anycentral
        for ((i1, expr1), (i2, expr2)) in Combinations(central, 2)
            @tryreturn mapsome(debugmatchtrycombine(simplifier, Op, expr1, expr2)) do combined
                replacesomeargs(operation, i1 => combined, i2 => nothing)
            end
        end
    end
    
    if anyordered
        for ((i1, expr1), (i2, expr2)) in adjacent(ordered)
            @tryreturn mapsome(debugmatchtrycombine(simplifier, Op, expr1, expr2)) do combined
                replacesomeargs(operation, i1 => combined, i2 => nothing)
            end
        end
    end

    if anycentral && anyordered
        for ((icentral, centralexpr), (iordered, orderedexpr)) in Iterators.product(central, ordered)
            @tryreturn mapsome(debugmatchtrycombine(simplifier, Op, centralexpr, orderedexpr)) do combined
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

    @tryreturn firstornothing(isabsorbing(operation), operation.arguments)
    
    if any(isidentity(operation), operation.arguments)
        return Associative{Op, T}(filter(!isidentity(operation), operation.arguments)) 
    end
    
    @tryreturn trysort(operation, CentralFirst(operation))

    @tryreturn @invoke trysimplify(operation, simplifier::Simplifier)
end

trysort(operation::Associative, order::Ordering) = if !issorted(operation.arguments; order)
    similar(operation, sort(operation.arguments; order))
end