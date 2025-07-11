"""
    apply_assoc(Op, value1, value2)

Evaluate associative `Op` exactly, returns `nothing` if not possible.
"""
apply_assoc(Op, value1, value2) = nothing

"""
    apply_assoc(transform::Transform, Op, value1, value2)

Evaluate associative `Op` (possibly approximately), according to `transform`, returns `nothing` if not possible.
"""
apply_assoc(transform::Transform, Op, value1, value2) = nothing
apply_assoc(::Trivial, Op, value1, value2) = apply_assoc(Op, value1, value2)

function trycombine(transform::Transform, Op, (value1,)::Literal, (value2,)::Literal)
    mapsome(apply_assoc(transform, Op, value1, value2)) do newvalue
        Literal(newvalue)
    end
end

"""
    apply_operation(Op, values...)

Evaluate `Op` exactly, returns `nothing` if not possible.
"""
apply_operation(Op, values...) = nothing

"""
    apply_operation(transform::Transform, Op, values...)

Evaluate `Op` (possibly approximately), according to `transform`, returns `nothing` if not possible.
"""
apply_operation(transform::Transform, Op, values...) = nothing
apply_operation(::Trivial, Op, values...) = apply_operation(Op, values...)

function tryapply(func::Operation{Op, N, T, <:NTuple{N, Literal}}, transform::Transform) where {N, Op, T}
    values = map(value, args(func))

    mapsome(apply_operation(transform, Op, values...)) do newvalue
        Literal(newvalue)
    end
end