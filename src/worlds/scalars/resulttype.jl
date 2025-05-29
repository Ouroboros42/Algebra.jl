const NUMBER_PROMOTING_OPS = Union{typeof(+), typeof(*)} 

resulttype(::NUMBER_PROMOTING_OPS, ::Type{N1}, ::Type{N2}) where {N1 <: Number, N2 <: Number} = numeric_resulttype(N1, N2)

numeric_resulttype(::Type{N1}, ::Type{N2}) where {N1 <: Number, N2 <: Number} = promote_type(N1, N2)

const LogicalComplex = Union{Real, Complex}

realtype(::Type{R}) where {R <: Real} = R
realtype(::Type{C}) where {C <: Complex} = fieldtype(C, :re)

# Non-specific Complex types do not promote properly, so we manually override here
numeric_resulttype(::Type{R1}, ::Type{R2}) where {R1 <: Real, R2 <: Real} = promote_type(R1, R2)
numeric_resulttype(::Type{C1}, ::Type{C2}) where {C1 <: LogicalComplex, C2 <: LogicalComplex} = Complex{promote_type(realtype(C1), realtype(C2))}
