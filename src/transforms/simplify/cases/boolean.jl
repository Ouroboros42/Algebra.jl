apply_operation(::typeof(==), a, b) = a == b

apply_operation(::typeof(!), a::Bool) = !a

tryapply(::Trivial, notnot::Not{Bool, <:Tuple{Not}}) = arg(arg(notnot))