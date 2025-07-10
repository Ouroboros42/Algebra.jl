simple_valtype(::typeof(^), base::Type{<:Complex}, ::Type{<:LogicalInt}) = base
simple_valtype(::typeof(^), base::Type{<:Real}, ::Type{<:LogicalInt}) = base
simple_valtype(::typeof(^), base::Type{<:LogicalInt}, ::Type{<:Signed}) = Union{base, Rational{base}}
simple_valtype(::typeof(^), base::Type{<:Real}, exponent::Type{<:Real}) = promote_type(base, exponent)

function apply_simple(Op::typeof(^), base::ComplexExact, exponent::ComplexExact)
    intexponent = @returnnothing maybeinteger(exponent)
    
    if iszero(intexponent); return one(base) end

    if exponent > 0; return Op(base, exponent) end

    Op(realconvert(Rational, base), exponent)
end

function apply_simple(::ApproxFloat{F}, Op::typeof(^), base::LogicalComplex, exponent::LogicalComplex) where F
    Op(realconvert(F, base), realconvert(F, exponent))
end
