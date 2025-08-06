determine(::Variable, ::Statement) = nothing
determine(var::Variable, equality::Equality) = if any(isequal(var), args(equality))
    firstornothing(args(equality)) do expr
        isempty(dependencies(expr))
    end
end
determine(var::Variable) = statement -> determine(var, statement)

trysimplify(simplifier, var::Variable) = firstresult(determine(var), contexts(simplifier))
