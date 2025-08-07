tryinfervaltype(::Type{<:Pow}, base::Type{<:LogicalComplex}, ::Type{<:LogicalInt}) = base
tryinfervaltype(::Type{<:Pow}, base::Type{<:Real}, ::Type{<:LogicalInt}) = base
tryinfervaltype(::Type{<:Pow}, base::Type{<:LogicalInt}, ::Type{<:Signed}) = Union{base, Rational{base}}
tryinfervaltype(::Type{<:Pow}, base::Type{<:Real}, exponent::Type{<:Real}) = promote_type(base, exponent)

function tryevaluate(simplifier, ::Type{<:Pow}, base::ComplexExact, exponent::ComplexExact)
    mapsome(maybeinteger(exponent)) do intexponent
        if exponent >= 0; return base ^ intexponent end

        realconvert(Rational, base) ^ intexponent
    end
end

function tryevaluate(simplifier, ::Type{<:Pow}, base::LogicalComplex, exponent::LogicalComplex)
    mapsome(floattype(simplfier)) do approxreal
        realconvert(approxreal, base) ^ realconvert(approxreal, exponent)
    end
end
