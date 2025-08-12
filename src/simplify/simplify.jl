function simplify(simplifier, expression::Expression, max_iterations = 1000)
    iterator = isnothing(max_iterations) ? Iterators.repeated(nothing) : (1:max_iterations)

    for _ in iterator
        maybe_simpler = trysimplify(simplifier, expression)

        if isnothing(maybe_simpler); return expression end
        
        @debug "Using $simplifier: $(expression) to $(maybe_simpler)"

        expression = maybe_simpler
    end

    @error "Simplifier reached max iterations ($max_iterations), presumably indicating an infinite loop.\nReached: $expression"

    expression
end

simplify(simplifier, expressions; kwargs...) = map(expr -> simplify(simplifier, expr; kwargs...), expressions)