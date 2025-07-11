"""
    operation_valtype(Op, T...)

Implement to determine the result of applying the given the associative `Op` to expressions of types `T`.
"""
operation_valtype(Op, T...) = throw(ResultTypeUndefinedError{Operation{Op, length(T)}}(T...))
operation_valtype(Op, arguments::Expression...) = operation_valtype(Op, map(valtype, arguments)...)

operation_isvalid(Op, args...) = !isnothing(operation_valtype(Op, args...))

isvalid(::Type{<:Operation{Op}}, args...) where Op = operation_isvalid(Op, args...)