trysimplify(simplifier) = expression -> trysimplify(simplifier, expression)
trysimplify(simplifier, expression::Expression) = mapsome(c -> tryimply(c, expression), context(simplifier))

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

    trycombine(simplifier, typeof(operation), args(operation)...)
end