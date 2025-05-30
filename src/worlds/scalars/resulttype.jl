const NUMBER_PROMOTING_OPS = Union{typeof(+), typeof(*)} 

assoc_valtype(::NUMBER_PROMOTING_OPS, N1::Type{<:Number}, N2::Type{<:Number}) = logical_promote_number(N1, N2)
nfunc_valtype(::typeof(^), N1::Type{<:Number}, N2::Type{<:Number}) = logical_promote_number(N1, N2)

logical_promote_number(N1::Type{<:Number}, N2::Type{<:Number}) = promote_type(N1, N2)

const LogicalComplex = Union{Real, Complex}

realtype(R::Type{<:Real}) = R
realtype(C::Type{<:Complex}) = fieldtype(C, :re)

# Non-specific Complex types do not promote properly, so we manually override here
logical_promote_number(R1::Type{<:Real}, R2::Type{<:Real}) = promote_type(R1, R2)
logical_promote_number(C1::Type{<:LogicalComplex}, C2::Type{<:LogicalComplex}) = Complex{logical_promote_number(realtype(C1), realtype(C2))}