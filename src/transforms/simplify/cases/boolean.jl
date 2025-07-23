tryevaluate(::Trivial, ::Type{<:Equality}, a, b) = a == b

tryevaluate(::Trivial, ::Type{<:Not}, a::Bool) = !a

trycombine(::Trivial, ::Type{<:Not}, not::Not) = arg(not)