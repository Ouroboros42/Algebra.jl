const NUMBER_PROMOTING_OPS = Union{typeof(+), typeof(*)} 

assoc_valtype(::NUMBER_PROMOTING_OPS, ::Type{N1}, ::Type{N2}) where {N1 <: Number, N2 <: Number} = logical_promote_number(N1, N2)
nfunc_valtype(::typeof(^), ::Type{N1}, ::Type{N2}) where {N1 <: Number, N2 <: Number} = logical_promote_number(N1, N2)

logical_promote_number(::Type{N1}, ::Type{N2}) where {N1 <: Number, N2 <: Number} = promote_type(N1, N2)

const LogicalComplex = Union{Real, Complex}

realtype(::Type{R}) where {R <: Real} = R
realtype(::Type{C}) where {C <: Complex} = fieldtype(C, :re)

# Non-specific Complex types do not promote properly, so we manually override here
logical_promote_number(::Type{R1}, ::Type{R2}) where {R1 <: Real, R2 <: Real} = promote_type(R1, R2)
logical_promote_number(::Type{C1}, ::Type{C2}) where {C1 <: LogicalComplex, C2 <: LogicalComplex} = Complex{logical_promote_number(realtype(C1), realtype(C2))}