apply_simple(::typeof(==), a, b) = a == b

apply_simple(::typeof(!), a::Bool) = !a

trysimplify(notnot::Not{Bool, <:Tuple{Not}}, ::Trivial) = arg(arg(notnot))