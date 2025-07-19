const IfElse = @operator Operation{ifelse, 3}

condition(conditional::IfElse) = args(conditional)[1]
truebranch(conditional::IfElse) = args(conditional)[2]
falsebranch(conditional::IfElse) = args(conditional)[3]

operation_valtype(::typeof(ifelse), ::Type{Bool}, truetype::Type, falsetype::Type) = Union{truetype, falsetype}
