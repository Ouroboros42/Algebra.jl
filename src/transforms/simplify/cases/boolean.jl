apply_operation(::typeof(==), a, b) = a == b

apply_operation(::typeof(!), a::Bool) = !a

tryapply(notnot::Not{Bool, <:Tuple{Not}}, ::Trivial) = arg(arg(notnot))