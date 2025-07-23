function tryinfervaltype(outer::Type{<:Sum}, A1::Type{<:AbstractArray{T1, N}}, A2::Type{<:AbstractArray{T2, N}}) where {T1, T2, N}
    mapsome(tryinfervaltype(outer, T1, T2)) do T
        AbstractArray{T, N}
    end
end