NUMBER_PROMOTING_OPS = Union{typeof(+), typeof(*)} 

resulttype(::NUMBER_PROMOTING_OPS, ::Type{N1}, ::Type{N2}) where {N1 <: Number, N2 <: Number} = promote_type(N1, N2)