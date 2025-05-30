const RealExact = Union{Integer, Rational, AbstractIrrational}
const ComplexExact = Union{RealExact, Complex{<:RealExact}}

const LogicalInt = Union{Signed, Unsigned}
const LogicalRational = Union{LogicalInt, Rational{<:LogicalInt}}
inttype(N::Type{<:LogicalInt}) = N
inttype(R::Type{<:LogicalRational}) = fieldtype(R, :num)

const LogicalComplex = Union{Real, Complex}
realtype(R::Type{<:Real}) = R
realtype(C::Type{<:Complex}) = fieldtype(C, :re)

const CVector = Vector{<:LogicalComplex}
const CMatrix = Matrix{<:LogicalComplex}
const CArray = Array{<:LogicalComplex}

const CLinear = Union{LogicalComplex, CArray}

iscommutative(::Type{<:Sum{<:CLinear}}) = true
iscommutative(::Type{<:Prod{<:LogicalComplex}}) = true