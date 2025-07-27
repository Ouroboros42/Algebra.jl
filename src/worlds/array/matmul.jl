function tryinfervaltype(outer::Type{<:Prod}, M1::Type{<:AbstractMatrix}, M2::Type{<:AbstractMatrix})
    mapsome(T -> AbstractMatrix{T}, tryinfervaltype(outer, valtype(M1), valtype(M2)))
end

function tryinfervaltype(outer::Type{<:Pow}, M::Type{<:AbstractMatrix}, N::Type{<:LogicalInt})
    mapsome(T -> AbstractMatrix{T}, tryinfervaltype(outer, valtype(M), N))
end
