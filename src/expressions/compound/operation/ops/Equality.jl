const Equality = @operator Operation{==, 2}

# Prevent `isequal` fallback to `==` which is now non-boolean
isequal(expr::Expression, other) = false
isequal(other, expr::Expression) = false
isequal(expr1::Expression, expr2::Expression) = false

lhs(equality::Equality) = args(equality)[1]
rhs(equality::Equality) = args(equality)[2]

print(io::IO, equality::Equality) = print(io, "$(lhs(equality)) = $(rhs(equality))")

operation_valtype(::typeof(==), ::Type, ::Type) = Bool

