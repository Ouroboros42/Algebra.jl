abstract type Simplifier end

function simplify(simplifier::Simplifier, expression::Expression, max_iterations = 1_000_000)
    for _ in 1:max_iterations
        maybe_simpler = trysimplify(simplifier, expression)

        if isnothing(maybe_simpler); return expression end
        
        @debug "Using $simplifier: $(expression) to $(maybe_simpler)"

        expression = maybe_simpler
    end

    @error "Simplifier reached max iterations ($max_iterations), got to $expression"

    expression
end