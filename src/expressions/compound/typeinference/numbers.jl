NUMBER_PROMOTING_OPS = Union{typeof(+), typeof(*)} 

resulttype(::NUMBER_PROMOTING_OPS, ::Type{N1}, ::Type{N2}) where {N1 <: Number, N2 <: Number} = numeric_resulttype(N1, N2)

numeric_resulttype(::Type{N1}, ::Type{N2}) where {N1 <: Number, N2 <: Number} = promote_type(N1, N2)

realtype(::Type{C}) where {C <: Complex} = fieldtype(C, :re)

# Non-specific Complex types do not promote properly, so we manually override here
numeric_resulttype(::Type{C}, ::Type{R}) where {C <: Complex, R <: Real} = Complex{promote_type(realtype(C), R)}
numeric_resulttype(::Type{R}, ::Type{C}) where {R <: Real, C <: Complex} = numeric_resulttype(C, R)
numeric_resulttype(::Type{C1}, ::Type{C2}) where {C1 <: Complex, C2 <: Complex} = Complex{promote_type(realtype(C1), realtype(C2))}