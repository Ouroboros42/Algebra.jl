function assoc_valtype(Op::typeof(+), A1::Type{<:AbstractArray{T1, N}}, A2::Type{<:AbstractArray{T2, N}}) where {T1, T2, N}
    AbstractArray{assoc_valtype(Op, T2, T2), N}
end

