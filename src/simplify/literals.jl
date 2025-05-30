assoc_exact(Op, value1, value2) = false

"""
    apply_assoc(Op, value1, value2)

Computed value of `Op` applied to `value1` and `value2`.
Default is to call `Op(value1, value2)`. Overload for other behaviour. 
"""
apply_assoc(Op, value1, value2) = Op(value1, value2)

function trycombine(::Trivial, Op, (value1,)::Literal, (value2,)::Literal)
    if !assoc_exact(Op, value1, value2); return end

    newvalue = apply_assoc(Op, value1, value2)

    @debug "$Op($value1, $value2) = $newvalue"

    Literal(newvalue)
end

nfunc_exact(Op, values...) = false

"""
    apply_nfunc(Op, values...)

Computed value of `Op` applied to `values`.
Default is to call `Op(values...)`. Overload for other behaviour. 
"""
apply_nfunc(Op, values...) = Op(values...)

function trysimplify(func::NFunc{N, Op, T, <:NTuple{N, Literal}}, ::Trivial) where {N, Op, T}
    values = map(value, args(func))

    if !nfunc_exact(Op, values...); return end

    newvalue = apply_nfunc(Op, values...)

    @debug "$Op$values = $newvalue"
    
    if !(newvalue isa T)
        @error "$(typeof(func)) $func evaluated to $(typeof(newvalue)): $newvalue"
    end

    Literal(newvalue)
end