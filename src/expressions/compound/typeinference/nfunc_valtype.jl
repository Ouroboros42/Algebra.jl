"""
    nfunc_valtype(Op, T...)

Implement to determine the result of applying the given the associative `Op` to expressions of types `T`.
"""
nfunc_valtype(Op, T...) = throw(ResultTypeUndefinedError{NFunc{Op, length(T)}}(T...))
nfunc_valtype(Op, arguments::Expression...) = nfunc_valtype(Op, map(valtype, arguments)...)

nfunc_isvalid(Op, args...) = !isnothing(nfunc_valtype(Op, args...))

isvalid(::Type{<:NFunc{Op}}, args...) where Op = nfunc_isvalid(Op, args...)