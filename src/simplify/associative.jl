import Combinat: Combinations

"""
    trycombine(simplifier::Simplifier, Op, expression1::Expression, expression2::Expression)

Override for types which can be combined together under the given operation."""
trycombine(::Simplifier, Op, ::Expression, ::Expression) = nothing

toargs(::Associative, expr::Expression) = [ expr ]
toargs(::Associative{Op}, expr::Associative{Op}) where Op = expr.arguments
toargs(op) = expr -> toargs(op, expr) 

function flatten(operation::Associative)
    similar(operation, collect(Iterators.flatmap(toargs(operation), args(operation))))
end

adjacent_pairs(operation::Associative{Op, T, true}) where {Op, T} = Combinations(ienumerate(args(operation)), 2)

"""
Iterate pairs of arguments, with their index, that are adjacent according to commutativity rules.
The first argument is at the position in the array that both arguments are commuted to.
"""
function adjacent_pairs(operation::Associative{Op}) where Op
    opargs = args(operation)

    Iterators.flatmap(pairs(opargs)) do (i1, expr1)
        Iterators.flatmap((-1, +1), (1, length(opargs))) do step, stop
            Iterators.map(
                Iterators.takewhile(
                    Iterators.map(i1+step:step:stop) do i2
                        (opargs[i2-step], i2, opargs[i2])
                    end
                ) do (prevexpr, _, _)
                    commutesunder(Op, expr1, prevexpr)
                end
            ) do (_, i2, expr2)
                (i2, expr2), (i1, expr1)
            end
        end
    end
end

function trysimplify(operation::Associative{Op}, simplifier::Simplifier) where Op
    for ((i1, expr1), (i2, expr2)) in adjacent_pairs(operation)
        reverse_order = i1 > i2

        if reverse_order
            expr1, expr2 = expr2, expr1
        end

        combined = trycombine(simplifier, Op, expr1, expr2)

        if !isnothing(combined)
            @debug "Combined $Op($expr1, $expr2) -> $combined"
            
            opargs = args(operation)

            new_args = if reverse_order
                Expression[ opargs[begin:i2-1]; opargs[i2+1:i1-1]; combined; opargs[i1+1:end] ]
            else
                Expression[ opargs[begin:i1-1]; combined; opargs[i1+1:i2-1]; opargs[i2+1:end] ]
            end
            
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
