function propagate(simplifier::Contextual, compound::Compound)
    @tryreturn mapsome(argcontexts(compound)) do contexts
        mapfirst(compound, contexts) do subexpr, context
            tryapply(updatecontext(simplifier, context), subexpr)
        end
    end
    
    @invoke propagate(simplifier::Simplifier, compound)
end

argcontexts(compound::Compound) = nothing

argcontexts(outer::And) = Iterators.map(otherargs -> And(otherargs, TRUE), others(args(outer)))
argcontexts(outer::Or) = Iterators.map(otherargs -> And(.!otherargs, TRUE), others(args(outer)))

argcontexts(outer::IfElse) = (nothing, condition(outer), !condition(outer))