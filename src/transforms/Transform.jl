abstract type Transform end

apply(transforms...) = expression -> apply(expression, transforms...)
apply(expression::Expression, transforms::Transform...) = apply(expression, transforms)

"""
Apply specified transforms to the Expression until it can be updated no more.
Should not need overriding, override `tryapply` instead.
"""
function apply(expression::Expression, transforms::NTuple{N, Transform}) where N
    for tranforms in transforms
        maybe_transformed = tryapply(expression, tranforms)

        if !isnothing(maybe_transformed)
            @debug "Using $tranforms: $(expression) to $(maybe_transformed)"

            return apply(maybe_transformed, transforms)
        end
    end

    expression
end

tryapply(::Expression, ::Transform) = nothing

