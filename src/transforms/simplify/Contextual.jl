struct Contextual{C <: Statement, S <: Simplifier} <: Simplifier
    simplifier::S
    context::C
end

tryapply(contextual::Contextual, expression::Expression) = tryapply(contextual.simplifier, expression)