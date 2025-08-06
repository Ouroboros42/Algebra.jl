const RealExact = Union{Integer, Rational}
const ComplexExact = Union{RealExact, Complex{<:RealExact}}

const LogicalInt = Union{Signed, Unsigned}
const LogicalRational = Union{LogicalInt, Rational{<:LogicalInt}}
inttype(N::Type{<:LogicalInt}) = N
inttype(R::Type{<:LogicalRational}) = fieldtype(R, :num)

const LogicalComplex = Union{Real, Complex}
realtype(R::Type{<:Real}) = R
realtype(C::Type{<:Complex}) = fieldtype(C, :re)
realtype(::Type{Union{A, B}}) where {A, B} = Union{realtype(A), realtype(B)}

realconvert(R::Type{<:Real}, value::Real) = convert(R, value)
realconvert(R::Type{<:Real}, value::Complex) = convert(Complex{R}, value)

const CVector = AbstractVector{<:LogicalComplex}
const CMatrix = AbstractMatrix{<:LogicalComplex}
const CArray = AbstractArray{<:LogicalComplex}

const CLinear = Union{LogicalComplex, CArray}