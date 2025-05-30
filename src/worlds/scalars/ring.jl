const PROMOTING_ASSOC_OPS = Union{typeof(+), typeof(*)}

function apply_assoc(Op::PROMOTING_ASSOC_OPS, n1::Number, n2::Number)
    newtype = logical_promote(typeof(n1), typeof(n2))
    
    Op(convert(newtype, n1), convert(newtype, n2))
end

assoc_exact(Op, n1::Number, n2::Number) = assoc_valtype(Op, typeof(n1), typeof(n2)) <: ComplexExact

assoc_valtype(::PROMOTING_ASSOC_OPS, N1::Type{<:Number}, N2::Type{<:Number}) = logical_promote(N1, N2)

logical_promote(N1::Type{<:Number}, N2::Type{<:Number}) = promote_type(N1, N2)

# Non-specific Complex types do not promote properly, so we manually override here
logical_promote(R1::Type{<:Real}, R2::Type{<:Real}) = promote_type(R1, R2)
logical_promote(C1::Type{<:LogicalComplex}, C2::Type{<:LogicalComplex}) = Complex{logical_promote(realtype(C1), realtype(C2))}

# Unsigned ints sometimes eat ints, this must be prevented
logical_promote(N1::Type{<:LogicalInt}, N2::Type{<:LogicalInt}) = promote_type(signed(N1), signed(N2))
logical_promote(U1::Type{<:Unsigned}, U2::Type{<:Unsigned}) = promote_type(U1, U2)
logical_promote(R1::Type{<:LogicalRational}, R2::Type{<:LogicalRational}) = Rational{logical_promote(inttype(R1), inttype(R2))}