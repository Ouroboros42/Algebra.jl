abstract type Simplifier <: Transform end

function apply(simplifier::Simplifier, expression::Expression)
    maybe_simpler = tryapply(simplifier, expression)

    if !isnothing(maybe_simpler)
        @debug "Using $simplifier: $(expression) to $(maybe_simpler)"

        return apply(simplifier, maybe_simpler)
    end

    expression
end

# Apply to subexpressions first, then try to apply simplifications the whole expression
apply(simplifier::Simplifier, compound::Compound) = @invoke apply(simplifier, (@invoke apply(simplifier::Transform, compound))::Expression)
