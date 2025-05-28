const CScalars = Union{Real, Complex}
const CVectors = Array{<:CScalars}
const CLinear = Union{CScalars, CVectors}

iscommutative(::Type{S}) where {S <: Sum{<:CLinear}} = true
iscommutative(::Type{P}) where {P <: Prod{<:CScalars}} = true

opidentity(::Type{S}) where {S <: Sum} = zero(S)
opidentity(::Type{P}) where {P <: Prod} = one(P)
