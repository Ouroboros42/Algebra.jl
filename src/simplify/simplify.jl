function simplify(simplifier, expression::Expression, max_iterations = 1_000_000)
    for _ in 1:max_iterations
        maybe_simpler = trysimplify(simplifier, expression)

        if isnothing(maybe_simpler); return expression end
        
        @debug "Using $simplifier: $(expression) to $(maybe_simpler)"

        expression = maybe_simpler
    end

    @error "Simplifier reached max iterations ($max_iterations), got to $expression"

    expression
end


trysimplify(simplifier) = expression -> trysimplify(simplifier, expression)
trysimplify(simplifier, expression::Expression) = mapsome(c -> tryimply(c, expression), context(simplifier))

tryimply(::Statement, ::Expression) = nothing
andargs(statement::Statement) = toargs(And, statement)
andargs(statement::Literal{Bool}) = Expression[]

function trysimplify(simplifier, compound::Compound)
    @tryreturn propagate(simplifier, compound)
    @tryreturn liftconditionals(compound)
    @invoke trysimplify(simplifier, compound::Expression)
end

function propagate(simplifier, compound::Compound)
    if iscontextual(simplifier)
        @tryreturn mapsome(argcontexts(compound)) do contexts
            mapfirst(compound, contexts) do subexpr, context
                trysimplify(updatecontext(simplifier, context), subexpr)
            end
        end
    end
    
    mapfirst(trysimplify(simplifier), compound)
end

function trysimplify(simplifier, operation::Operation)
    @tryreturn @invoke trysimplify(simplifier, operation::Compound)

    trycombine(simplifier, logicaltype(operation), args(operation)...)
end

"""
Override for types which can be combined together under the given operation.
Returns `nothing` if no transform for the combination is possible.
`outer` should generally only be used for its type.
"""
trycombine(simplifier, outer::Type{<:Compound}, args::Expression...) = nothing
trycombine(simplifier, outer::Compound, args...) = trycombine(simplifier, logicaltype(outer), args...)

trycombine(simplifier, outer::Type{<:Compound}, args::Literal...) = mapsome(Literal, tryevaluate(simplifier, outer, map(value, args)...))

tryevaluate(simplifier, outer::Type{<:Compound}, args...) = nothing

"""
Override if `initial` has equivalent forms more suitable to combine with `target`.
Returns a sequence of all possible forms.
"""
matchingforms(simplifier, ::Type{<:Compound}, target::Expression, initial::Expression) = ()

matchtrycombine(simplifier, outer::Compound, expr1::Expression, expr2::Expression) = matchtrycombine(simplifier, logicaltype(outer), expr1, expr2)
function matchtrycombine(simplifier, outer::Type{<:Compound}, expr1::Expression, expr2::Expression)
    @tryreturn trycombine(simplifier, outer, expr1, expr2)

    for form2 in matchingforms(simplifier, outer, expr1, expr2)
        @tryreturn trycombine(simplifier, outer, expr1, form2)
    end

    for form1 in matchingforms(simplifier, outer, expr2, expr1)
        @tryreturn trycombine(simplifier, outer, form1, expr2)
    end
end