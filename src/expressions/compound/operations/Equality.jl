const Equality = NFunc{==, 2}

lhs(equality::Equality) = args(equality)[1]
rhs(equality::Equality) = args(equality)[2]

print(io::IO, equality::Equality) = print(io, "$(lhs(equality)) = $(rhs(equality))")

nfunc_valtype(::typeof(==), ::Type, ::Type) = Bool
