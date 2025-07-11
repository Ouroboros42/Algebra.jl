const Not = @operator Operation{!, 1}

arg(not::Not) = only(args(not))

print(io::IO, not::Not) = print(io, "!($(arg(not)))")

simple_valtype(::typeof(!), ::Type{Bool}) = Bool

