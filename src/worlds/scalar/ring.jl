const RingOps = Union{typeof(+), typeof(*)}

iscentral(::typeof(+), ::Expression{<:CLinear}) = true
iscentral(::typeof(*), ::Expression{<:LogicalComplex}) = true

assoc_valtype(::RingOps, N1::Type{<:Number}, N2::Type{<:Number}) = ring_promote(N1, N2)

ring_promote(U1::Type{<:Unsigned}, U2::Type{<:Unsigned}) = promote_type(U1, U2)
ring_promote(N1::Type{<:LogicalInt}, N2::Type{<:LogicalInt}) = promote_type(signed(N1), signed(N2))
ring_promote(R1::Type{<:LogicalRational}, R2::Type{<:LogicalRational}) = Rational{ring_promote(inttype(R1), inttype(R2))}
ring_promote(R1::Type{<:Real}, R2::Type{<:Real}) = promote_type(R1, R2)
ring_promote(C1::Type{<:LogicalComplex}, C2::Type{<:LogicalComplex}) = Complex{ring_promote(realtype(C1), realtype(C2))}

function apply_assoc(Op::RingOps, n1::ComplexExact, n2::ComplexExact)
    newtype = ring_promote(typeof(n1), typeof(n2))
    if !(newtype <: ComplexExact); return end

    Op(convert(newtype, n1), convert(newtype, n2))    
end

function apply_assoc(::FloatApprox{F}, Op::RingOps, n1::LogicalComplex, n2::LogicalComplex) where F
    Op(realconvert(F, n1), realconvert(F, n2))
end
