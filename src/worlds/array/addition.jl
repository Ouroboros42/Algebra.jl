function tryinfervaltype(outer::Type{<:Sum}, A1::Type{<:AbstractArray{T1, N}}, A2::Type{<:AbstractArray{T2, N}}) where {T1, T2, N}
    mapsome(T -> AbstractArray{T, N}, tryinfervaltype(outer, T1, T2))
end