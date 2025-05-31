"""
    assoc_valtype(Op, T1, T2)

Implement to determine the result of applying the given the associative `Op` to expressions of type `T1`, `T2`.
"""
assoc_valtype(Op, T1, T2) = throw(ResultTypeUndefinedError{Associative{Op}}(T1, T2))
assoc_valtype(Op) = (T1, T2) -> assoc_valtype(Op, T1, T2)

assoc_isvalid(args...) = !isnothing(assoc_valtype(args...))
isvalid(::Type{<:Associative{Op}}, args...) where Op = assoc_isvalid(Op, args...)

isclosed(Op, T) = assoc_valtype(Op, T, T) <: T

closed_valtype(Op, E) = mapsome(valtype(E)) do T
    if isclosed(Op, T)
        T
    end
end

function assoc_valtype(Op, (expr, others...)::NTuple{N, Expression}) where N
    if isempty(others); return valtype(expr) end

    assoc_valtype(Op, valtype(expr), assoc_valtype(Op, others))
end

function assoc_valtype(Op, expressions::NTuple{N, E}) where {N, E <: Expression}
    @tryreturn closed_valtype(Op, E)

    @invoke assoc_valtype(Op, expressions::NTuple{N, Expression})    
end

assoc_valtype(Op, expressions::Expression...) = assoc_valtype(Op, expressions)

function assoc_valtype(Op, expressions::Vector{E}) where {E <: Expression}
    if isempty(expressions); throw(DomainError("Cannot infer result type of empty $Op")) end

    @tryreturn closed_valtype(Op, E)

    mapreduce(valtype, assoc_valtype(Op), expressions)
end
