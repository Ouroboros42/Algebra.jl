"""
    apply_assoc(Op, value1, value2)

Evaluate associative `Op` exactly, returns `nothing` if not possible.
"""
apply_assoc(Op, value1, value2) = nothing

"""
    apply_assoc(simplifier::Simplifier, Op, value1, value2)

Evaluate associative `Op` (possibly approximately), according to `simplifier`, returns `nothing` if not possible.
"""
apply_assoc(simplifier::Simplifier, Op, value1, value2) = nothing
apply_assoc(::Trivial, Op, value1, value2) = apply_assoc(Op, value1, value2)

function trycombine(simplifier::Simplifier, Op, (value1,)::Literal, (value2,)::Literal)
    mapsome(apply_assoc(simplifier, Op, value1, value2)) do newvalue
        Literal(newvalue)
    end
end

"""
    apply_nfunc(Op, values...)

Evaluate `Op` exactly, returns `nothing` if not possible.
"""
apply_nfunc(Op, values...) = nothing

"""
    apply_nfunc(simplifier::Simplifier, Op, values...)

Evaluate `Op` (possibly approximately), according to `simplifier`, returns `nothing` if not possible.
"""
apply_nfunc(simplifier::Simplifier, Op, values...) = nothing
apply_nfunc(::Trivial, Op, values...) = apply_nfunc(Op, values...)

function trysimplify(func::NFunc{Op, N, T, <:NTuple{N, Literal}}, simplifier::Simplifier) where {N, Op, T}
    values = map(value, args(func))

    mapsome(apply_nfunc(simplifier, Op, values...)) do newvalue
        Literal(newvalue)
    end
end