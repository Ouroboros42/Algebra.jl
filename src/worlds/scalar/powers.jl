operation_valtype(::typeof(^), base::Type{<:Complex}, ::Type{<:LogicalInt}) = base
operation_valtype(::typeof(^), base::Type{<:Real}, ::Type{<:LogicalInt}) = base
operation_valtype(::typeof(^), base::Type{<:LogicalInt}, ::Type{<:Signed}) = Union{base, Rational{base}}
operation_valtype(::typeof(^), base::Type{<:Real}, exponent::Type{<:Real}) = promote_type(base, exponent)

function tryevaluate(::Trivial, ::Type{<:Pow}, base::ComplexExact, exponent::ComplexExact)
    intexponent = @returnnothing maybeinteger(exponent)
    
    if iszero(intexponent); return one(base) end

    if exponent > 0; return base ^ exponent end

    realconvert(Rational, base) ^ exponent
end

function tryevaluate(::FloatApprox{F}, ::Type{<:Pow}, base::LogicalComplex, exponent::LogicalComplex) where F
    realconvert(F, base) ^ realconvert(F, exponent)
end
