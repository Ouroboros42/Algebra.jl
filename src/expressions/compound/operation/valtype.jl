"""
    simple_valtype(Op, T...)

Implement to determine the result of applying the given the associative `Op` to expressions of types `T`.
"""
simple_valtype(Op, T...) = throw(ResultTypeUndefinedError{Operation{Op, length(T)}}(T...))
simple_valtype(Op, arguments::Expression...) = simple_valtype(Op, map(valtype, arguments)...)

simple_isvalid(Op, args...) = !isnothing(simple_valtype(Op, args...))

isvalid(::Type{<:Operation{Op}}, args...) where Op = simple_isvalid(Op, args...)