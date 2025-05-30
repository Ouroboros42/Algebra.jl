"""
    nfunc_valtype(Op, T...)

Implement to determine the result of applying the given the associative `Op` to expressions of types `T`.
"""
nfunc_valtype(Op, T...) = throw(ResultTypeUndefinedError{NFunc{Op, length(T)}}(T...))

nfunc_valid(args...) = !isnothing(nfunc_valtype(args...))
