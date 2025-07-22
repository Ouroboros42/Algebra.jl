tryevaluate(::Type{<:Equality}, a, b) = a == b

tryevaluate(::Type{<:Not}, a::Bool) = !a

trycombine(::Trivial, ::Type{<:Not}, not::Not) = arg(not)