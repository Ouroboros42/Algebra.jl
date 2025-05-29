const CVector = Vector{<:LogicalComplex}
const CMatrix = Matrix{<:LogicalComplex}
const CArray = Array{<:LogicalComplex}

const CLinear = Union{LogicalComplex, CArray}

iscommutative(::Type{S}) where {S <: Sum{<:CLinear}} = true
iscommutative(::Type{P}) where {P <: Prod{<:LogicalComplex}} = true

opidentity(::Type{S}) where {S <: Sum} = zero(S)
opidentity(::Type{P}) where {P <: Prod} = one(P)
