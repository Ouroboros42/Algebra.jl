"""
    resulttype(Op, T1, T2)

Implement to determine the result of applying the given Op to the given expressions.
"""
function resulttype(Op, T1, T2)
    throw(ResultTypeUndefinedError{Op}(T1, T2))
end

resulttype(Op) = (T1, T2) -> resulttype(Op, T1, T2)
isclosed(Op, T) = resulttype(Op, T, T) <: T

skipresultrecursion(Op, E) = mapsome(valtype(E)) do T
    if isclosed(Op, T)
        T
    end
end

function resulttype(Op, (expr, others...)::NTuple{N, Expression}) where N
    if isempty(others); return valtype(expr) end

    resulttype(Op, valtype(expr), resulttype(Op, others))
end

function resulttype(Op, expressions::NTuple{N, E}) where {N, E <: Expression}
    @tryreturn skipresultrecursion(Op, E)

    @invoke resulttype(Op, expressions::NTuple{N, Expression})    
end

resulttype(Op, expressions::Expression...) = resulttype(Op, expressions)

function resulttype(Op, expressions::Vector{E}) where {E <: Expression}
    if isempty(expressions); throw(DomainError("Cannot infer result type of empty $Op")) end

    @tryreturn skipresultrecursion(Op, E)

    mapreduce(valtype, resulttype(Op), expressions)
end
