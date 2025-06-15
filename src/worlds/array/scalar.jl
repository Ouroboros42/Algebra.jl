function assoc_valtype(Op::typeof(*), T::Type, M::Type{<:AbstractMatrix})
    AbstractMatrix{assoc_valtype(Op, T, valtype(M))}
end

function assoc_valtype(Op::typeof(*), M::Type{<:AbstractMatrix}, T::Type)
    AbstractMatrix{assoc_valtype(Op, valtype(M), T)}
end