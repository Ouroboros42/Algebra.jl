const CVector = Vector{<:LogicalComplex}
const CMatrix = Matrix{<:LogicalComplex}
const CArray = Array{<:LogicalComplex}

const CLinear = Union{LogicalComplex, CArray}

iscommutative(::Type{<:Sum{<:CLinear}}) = true
iscommutative(::Type{<:Prod{<:LogicalComplex}}) = true