function tryinfervaltype(outer::Type{<:Prod}, T::Type, M::Type{<:AbstractMatrix})
    mapsome(tryinfervaltype(outer, T, valtype(M))) do T
        AbstractMatrix{T}
    end
end

function tryinfervaltype(outer::Type{<:Prod}, M::Type{<:AbstractMatrix}, T::Type)
    mapsome(tryinfervaltype(outer, valtype(M), T)) do T
        AbstractMatrix{T}
    end
end