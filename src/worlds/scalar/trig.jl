tryinfervaltype(::Type{<:Trig}, ::Type{<:Real}) = Real
tryinfervaltype(::Type{<:Trig}, ::Type{<:LogicalComplex}) = Complex

tryevaluate(simplifier, trig::Type{<:Trig}, value::LogicalComplex) = mapsome(floattype(simplifier)) do approxreal
    op(trig)(realconvert(approxreal, value))
end