function tryinfervaltype(outer::Type{<:Prod}, T::Type, M::Type{<:AbstractMatrix})
    mapsome(T -> AbstractMatrix{T}, tryinfervaltype(outer, T, valtype(M)))
end

function tryinfervaltype(outer::Type{<:Prod}, M::Type{<:AbstractMatrix}, T::Type)
    mapsome(T -> AbstractMatrix{T}, tryinfervaltype(outer, valtype(M), T))
end