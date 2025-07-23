const Not = @operator Operation{!, 1}

print(io::IO, not::Not) = print(io, "!($(arg(not)))")

tryinfervaltype(::Type{<:Not}, ::Type{Bool}) = Bool

