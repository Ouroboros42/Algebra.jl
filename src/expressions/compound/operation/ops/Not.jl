const Not = @operator Operation{!, 1}

print(io::IO, not::Not) = print(io, "!($(arg(not)))")

operation_valtype(::typeof(!), ::Type{Bool}) = Bool

