const IfElse = @operator Operation{ifelse, 3}

ifelse(condition::Bool, expr1::Expression, expr2::Expression) = @invoke ifelse(condition, expr1::Any, expr2::Any)

condition(conditional::IfElse) = args(conditional)[1]
truebranch(conditional::IfElse) = args(conditional)[2]
falsebranch(conditional::IfElse) = args(conditional)[3]

tryinfervaltype(::Type{<:IfElse}, ::Type{Bool}, truetype::Type, falsetype::Type) = Union{truetype, falsetype}

mapbranches(f, conditional::IfElse) = ifelse(condition(conditional), f(truebranch(conditional)), f(falsebranch(conditional)))