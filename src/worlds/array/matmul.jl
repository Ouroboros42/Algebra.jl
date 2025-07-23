function tryinfervaltype(outer::Type{<:Prod}, M1::Type{<:AbstractMatrix}, M2::Type{<:AbstractMatrix})
    mapsome(tryinfervaltype(outer, valtype(M1), valtype(M2))) do T
        AbstractMatrix{T}
    end
end

function tryinfervaltype(outer::Type{<:Pow}, M::Type{<:AbstractMatrix}, N::Type{<:LogicalInt})
    mapsome(tryinfervaltype(outer, valtype(M), N)) do T
        AbstractMatrix{T}
    end
end
