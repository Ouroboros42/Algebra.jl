function assoc_valtype(Op::typeof(*), M1::Type{<:AbstractMatrix}, M2::Type{<:AbstractMatrix})
    AbstractMatrix{assoc_valtype(Op, valtype(M1), valtype(M2))}
end

function simple_valtype(Op::typeof(^), M::Type{<:AbstractMatrix}, N::Type{<:LogicalInt})
    AbstractMatrix{simple_valtype(Op, valtype(M), N)}
end
