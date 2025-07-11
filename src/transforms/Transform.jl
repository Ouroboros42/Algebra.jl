abstract type Transform end

apply(transforms) = expression -> apply(transforms, expression)
apply(transform::Transform, expression::Expression) = apply((transform,), expression)

"""
Apply specified transforms to the Expression until it can be updated no more.
Should not need overriding, override `tryapply` instead.
"""
function apply(transforms::NTuple{N, Transform}, expression::Expression) where N
    for tranforms in transforms
        maybe_transformed = tryapply(tranforms, expression)

        if !isnothing(maybe_transformed)
            @debug "Using $tranforms: $(expression) to $(maybe_transformed)"

            return apply(transforms, maybe_transformed)
        end
    end

    expression
end

tryapply(::Transform, ::Expression) = nothing

