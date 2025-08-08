tryimply(assumptions::Statement, var::Variable) = firstresult(andargs(assumptions)) do assumption
    if assumption isa Equality && any(isequal(var), args(assumption))
        firstornothing(isconst, args(assumption))
    end
end

tryimply(assumptions::Statement, statement::Statement) = firstresult(andargs(assumptions)) do assumption
    if isequal(assumption, statement)
        return TRUE
    end

    if isequal(assumption, statement)
        return FALSE
    end
end

tryimply(assumptions::Statement, var::Variable{Bool}) = @invoke tryimply(assumptions, var::Statement)