import Combinat: Combinations

"""
    trycombine(simplifier::Simplifier, Op, expression1::Expression, expression2::Expression)

Override for types which can be combined together under the given operation."""
trycombine(simplifier::Simplifier, Op, ::Expression, ::Expression) = nothing

toargs(::Associative, expr::Expression) = [ expr ]
toargs(::Associative{Op}, expr::Associative{Op}) where Op = expr.arguments
toargs(op) = expr -> toargs(op, expr) 

function flatten(operation::Associative)
    similar(operation, collect(Iterators.flatmap(toargs(operation), args(operation))))
end

function trysimplify(operation::Associative{Op}, simplifier::Simplifier) where Op
    opargs = args(operation)

    iter_pairs = iscommutative(operation) ? Combinations(ienumerate(opargs), 2) : adjacent(ienumerate(opargs))

    for ((i1, expr1), (i2, expr2)) in iter_pairs
        combined = trycombine(simplifier, Op, expr1, expr2)

        if !isnothing(combined)
            @debug "Combined $Op($expr1, $expr2) -> $combined"
        
            new_type = Union{eltype(opargs), typeof(combined)}

            new_args = new_type[ opargs[begin:i1-1]; combined; opargs[i1+1:i2-1]; opargs[i2+1:end] ]

            return Associative{Op}(new_args)
        end
    end
end

function trysimplify(operation::Associative{Op}, simplifier::Trivial) where Op
    if isempty(args(operation))
        throw(EmptyOperationError{Op}())
    end

    @tryreturn onlyornothing(args(operation))

    if operation isa Prod
        @tryreturn firstornothing(iszero, args(operation))
    end

    if hasidentity(operation) && any(isidentity(operation), args(operation))
        return Associative{Op}(filter(!isidentity(operation), args(operation))) 
    end
    
    @tryreturn @invoke trysimplify(operation, simplifier::Simplifier)

    if any(isinst(Associative{Op}), args(operation))
        return flatten(operation)
    end
    
    if iscommutative(operation) && !issorted(args(operation))
        return Associative{Op}(sort(args(operation)))
    end
end
